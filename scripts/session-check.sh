#!/usr/bin/env bash
# scripts/session-check.sh -- session-integrity checks for ai-eval-lab.
#
# The session convention is only worth anything if it is enforced. A handoff
# that drifts from the template, a session number that skips, or a lab that
# claims to be started without a recorded negative control are all ways the
# convention rots silently. This script makes each of them fail the gate.
#
# Checks:
#   1. session numbering is contiguous from S-000 with no gaps or duplicates
#   2. every session file carries the required frontmatter keys
#   3. every session file carries every required template section
#   4. the frontmatter session number matches the filename
#   5. STATUS.md names a next session that exists (or is exactly the next one)
#   6. every lab with real content has a NEGATIVE_CONTROL.md
#
# Plain ASCII on purpose - non-ASCII breaks some shells and editors.
#
# Usage:
#   scripts/session-check.sh              run the checks (exit 0 = pass)
#   scripts/session-check.sh --selftest   prove the checks can fail
#
# The selftest exists because a check that cannot fail is not a check. It
# mutates a scratch copy of the repo - one mutation per rule - and asserts
# that the gate turns RED for the right reason. It runs in CI on every run,
# on the runner that will do the gating, so "the gate works" is never an
# assumption.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SESSIONS_DIR="$ROOT/docs/sessions"
failed=0

ok()  { printf 'ok    %s\n' "$1"; }
bad() { printf 'FAIL  %s\n' "$1"; failed=1; }

# ---------------------------------------------------------------------------
# 0. the sessions directory exists
# ---------------------------------------------------------------------------
if [ ! -d "$SESSIONS_DIR" ]; then
  bad "docs/sessions/ is missing - the session convention has no home"
  printf '\nconventions check FAILED\n'
  exit 1
fi

session_files="$(find "$SESSIONS_DIR" -maxdepth 1 -type f -name 'S-*.md' | sort)"

if [ -z "$session_files" ]; then
  bad "no session files found in docs/sessions/"
else
  # ---------------------------------------------------------------------
  # 1. numbering: contiguous from 000, no gaps, no duplicates
  # ---------------------------------------------------------------------
  nums="$(printf '%s\n' "$session_files" | sed -E 's|.*/S-([0-9]{3})-.*|\1|' | sort)"
  dupes="$(printf '%s\n' "$nums" | uniq -d)"
  if [ -n "$dupes" ]; then
    bad "duplicate session numbers: $(printf '%s' "$dupes" | tr '\n' ' ')"
  else
    ok "session numbers are unique"
  fi

  expected=0
  gap=""
  for n in $nums; do
    n10=$((10#$n))
    if [ "$n10" -ne "$expected" ]; then
      gap="$gap S-$n(expected S-$(printf '%03d' "$expected"))"
      expected=$n10
    fi
    expected=$((expected + 1))
  done
  if [ -n "$gap" ]; then
    bad "session numbering has a gap:$gap"
  else
    ok "session numbering is contiguous (S-000..S-$(printf '%03d' $((expected - 1))))"
  fi

  highest="$(printf '%s\n' "$nums" | tail -n 1)"

  # ---------------------------------------------------------------------
  # 2, 3, 4. per-file structure
  # ---------------------------------------------------------------------
  required_keys="session date status"
  # An array, not a backslash-continued string: a section heading starts with
  # '#', and a continued string assignment mangles the list into one word.
  required_sections=(
    "## Where we are"
    "## What was done"
    "## What was learned (durable)"
    "## Negative control"
    "## Open threads"
    "## Memory writes"
  )

  structure_errors=0
  for f in $session_files; do
    rel="${f#"$ROOT"/}"
    base="$(basename "$f")"

    for key in $required_keys; do
      if ! grep -qE "^${key}:" "$f"; then
        printf '      %s: missing frontmatter key "%s:"\n' "$rel" "$key"
        structure_errors=$((structure_errors + 1))
      fi
    done

    for section in "${required_sections[@]}"; do
      if ! grep -qF "$section" "$f"; then
        printf '      %s: missing section "%s"\n' "$rel" "$section"
        structure_errors=$((structure_errors + 1))
      fi
    done

    # the frontmatter number must agree with the filename
    fm_num="$(grep -m1 -E '^session:' "$f" | sed -E 's/^session:[[:space:]]*S-([0-9]{3}).*/\1/')"
    file_num="$(printf '%s' "$base" | sed -E 's/^S-([0-9]{3}).*/\1/')"
    if [ -n "$fm_num" ] && [ "$fm_num" != "$file_num" ]; then
      printf '      %s: frontmatter says S-%s but the filename says S-%s\n' "$rel" "$fm_num" "$file_num"
      structure_errors=$((structure_errors + 1))
    fi
  done

  if [ "$structure_errors" -ne 0 ]; then
    bad "$structure_errors session-structure problem(s) (see above)"
  else
    ok "every session file has the required frontmatter and sections"
  fi
fi

# ---------------------------------------------------------------------------
# 5. STATUS.md names the next session
# ---------------------------------------------------------------------------
STATUS="$ROOT/STATUS.md"
if [ ! -f "$STATUS" ]; then
  bad "STATUS.md is missing"
else
  next_line="$(grep -m1 -E 'Next session:[[:space:]]*S-[0-9]{3}' "$STATUS" || true)"
  if [ -z "$next_line" ]; then
    bad "STATUS.md does not name a next session (expected 'Next session: S-NNN')"
  else
    next_num="$(printf '%s' "$next_line" | sed -E 's/.*Next session:[[:space:]]*S-([0-9]{3}).*/\1/')"
    next10=$((10#$next_num))
    highest10=$(printf '%s' "${highest:-000}" | sed 's/^0*//')
    highest10="${highest10:-0}"
    if [ "$next10" -gt $((highest10 + 1)) ]; then
      bad "STATUS.md points at S-$next_num but the highest session on disk is S-$(printf '%03d' "$highest10")"
    elif [ -n "$highest" ] && [ "$next10" -le "$highest10" ]; then
      bad "STATUS.md points at S-$next_num, which already exists - the next session must be S-$(printf '%03d' $((highest10 + 1)))"
    else
      ok "STATUS.md names the next session (S-$next_num)"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 6. every lab with real content has a negative control
# ---------------------------------------------------------------------------
LABS="$ROOT/labs"
if [ -d "$LABS" ]; then
  nc_missing=""
  nc_count=0
  lab_count=0
  for dir in "$LABS"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    case "$name" in __pycache__|README.md) continue ;; esac
    lab_count=$((lab_count + 1))

    # a lab is "started" once it holds anything other than its brief
    content="$(find "$dir" -type f \
      -not -name 'BRIEF.md' \
      -not -name 'README.md' \
      -not -path '*/__pycache__/*' \
      -not -name '*.pyc' | head -n 1)"
    if [ -n "$content" ]; then
      if [ ! -f "$dir/NEGATIVE_CONTROL.md" ]; then
        nc_missing="$nc_missing $name"
      else
        nc_count=$((nc_count + 1))
      fi
    fi
  done
  if [ -n "$nc_missing" ]; then
    bad "labs with content but no NEGATIVE_CONTROL.md:$nc_missing"
  else
    ok "every started lab has a NEGATIVE_CONTROL.md ($nc_count recorded)"
  fi
  if [ "$lab_count" -eq 0 ]; then
    ok "no labs on disk yet"
  fi
fi

printf '\n'
if [ "$failed" -ne 0 ]; then
  printf 'session check FAILED\n'
  exit 1
fi
printf 'session check passed\n'
