#!/usr/bin/env bash
# scripts/session-selftest.sh -- prove the session gate can actually fail.
#
# WHY THIS EXISTS
#
# A check that cannot fail is not a check. The session-integrity rules in
# scripts/session-check.sh are load-bearing in this repo: they are the only
# thing standing between "a session happened" and "a session was assumed to
# have happened". If one of those rules silently stopped matching - because
# a heading was renamed, or a grep pattern drifted - the gate would keep
# printing green while the convention quietly rotted.
#
# So the rules are tested against deliberately broken copies of the repo.
# One mutation per rule. Each must turn the gate RED, and RED for the
# stated reason.
#
# This runs in CI on every run, on the runner that will do the gating, so
# "the gate works" is never an assumption. It mirrors the discipline in
# sentinel-qa's spec-diff gate selftest (INC-006: a gate built on a command
# that prints a failure and exits 0 would never turn red).
#
# File mutations are done with python3 rather than `sed -i`: the BSD and GNU
# sed disagree about the -i suffix, and this script runs on macOS locally
# and on ubuntu-latest in CI.
#
# Usage: scripts/session-selftest.sh   (exit 0 = all mutations detected)

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="$ROOT/scripts/session-check.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

pass=0
fail=0

ok()  { printf 'ok    %s\n' "$1"; }
bad() { printf 'FAIL  %s\n' "$1"; fail=$((fail + 1)); }

if [ ! -f "$SCRIPT" ]; then
  bad "scripts/session-check.sh not found - nothing to selftest"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  bad "python3 is required for the mutations"
  exit 1
fi

# ---------------------------------------------------------------------------
# helper: build a scratch copy of the repo and run the gate inside it
# ---------------------------------------------------------------------------
sandbox() {
  local name
  local dest
  name="$1"
  dest="$WORK/$name"
  mkdir -p "$dest"
  # copy the tree we care about, without git metadata or the venv
  (cd "$ROOT" && tar -cf - \
      --exclude='.git' \
      --exclude='.venv' \
      --exclude='__pycache__' \
      --exclude='node_modules' \
      . ) | (cd "$dest" && tar -xf -)
  printf '%s' "$dest"
}

# edit <file> <python-expression operating on `text`>
# The expression is evaluated by python, so it must be valid python source.
# `drop_heading` is provided as a helper: it removes every line starting
# with the given prefix, which is how a missing section or a missing
# frontmatter key looks.
edit() {
  python3 - "$1" "$2" <<'PY'
import sys
path, expr = sys.argv[1], sys.argv[2]
with open(path, "r", encoding="utf-8") as fh:
    text = fh.read()


def drop_heading(text, prefix):
    return "\n".join(l for l in text.split("\n") if not l.startswith(prefix))


with open(path, "w", encoding="utf-8") as fh:
    fh.write(eval(expr, {"text": text, "drop_heading": drop_heading}))
PY
}

# expect_red <label> <sandbox-path> <expected-substring>
# Runs the gate in the sandbox; it MUST exit non-zero AND the output must
# mention the expected reason. A mutation that turns the gate red for the
# WRONG reason is itself a failure - it means the rule is matching on
# something accidental.
expect_red() {
  local label="$1"
  local sb="$2"
  local want="$3"
  local out
  local code
  out="$(cd "$sb" && bash scripts/session-check.sh 2>&1)"
  code=$?
  if [ "$code" -eq 0 ]; then
    bad "$label - the gate stayed GREEN on a broken tree"
    printf '      %s\n' "$(printf '%s' "$out" | tail -n 3 | tr '\n' ' ')"
    return
  fi
  if ! printf '%s' "$out" | grep -qF "$want"; then
    bad "$label - the gate went red for the WRONG reason (expected '$want')"
    printf '      %s\n' "$(printf '%s' "$out" | grep -E '^FAIL' | head -n 2 | tr '\n' ' ')"
    return
  fi
  ok "$label - detected: $want"
  pass=$((pass + 1))
}

# ---------------------------------------------------------------------------
# 0. control: the pristine tree must be GREEN
# ---------------------------------------------------------------------------
clean="$(sandbox clean)"
out="$(cd "$clean" && bash scripts/session-check.sh 2>&1)"
if [ $? -eq 0 ]; then
  ok "control - an unmodified tree passes"
  pass=$((pass + 1))
else
  bad "control - an unmodified tree FAILED (the gate is broken before any mutation)"
  printf '      %s\n' "$(printf '%s' "$out" | grep -E '^FAIL' | head -n 3 | tr '\n' ' ')"
fi

# ---------------------------------------------------------------------------
# 1. a session-numbering gap must be red
# ---------------------------------------------------------------------------
# Renamed rather than hidden: hiding the only session file would trip the
# "no session files" rule instead of the numbering rule, and a mutation that
# goes red for the wrong reason is not a valid negative control.
sb="$(sandbox gap)"
mv "$sb/docs/sessions/S-000-init.md" "$sb/docs/sessions/S-002-init.md"
expect_red "gap in the session numbering" "$sb" "session numbering has a gap"

# ---------------------------------------------------------------------------
# 2. a handoff missing a required section must be red
# ---------------------------------------------------------------------------
sb="$(sandbox missing-section)"
edit "$sb/docs/sessions/S-000-init.md" 'drop_heading(text, "## Negative control")'
expect_red "a handoff missing a template section" "$sb" "missing section"

# ---------------------------------------------------------------------------
# 3. a handoff missing required frontmatter must be red
# ---------------------------------------------------------------------------
sb="$(sandbox missing-frontmatter)"
edit "$sb/docs/sessions/S-000-init.md" 'drop_heading(text, "status:")'
expect_red "a handoff missing frontmatter" "$sb" "missing frontmatter key"

# ---------------------------------------------------------------------------
# 4. frontmatter disagreeing with the filename must be red
# ---------------------------------------------------------------------------
sb="$(sandbox mismatched-number)"
edit "$sb/docs/sessions/S-000-init.md" 'text.replace("session: S-000", "session: S-042", 1)'
expect_red "frontmatter disagreeing with the filename" "$sb" "but the filename says"

# ---------------------------------------------------------------------------
# 5. STATUS.md not naming a next session must be red
# ---------------------------------------------------------------------------
sb="$(sandbox no-next-session)"
edit "$sb/STATUS.md" 'text.replace("**Next session: S-001", "Next session removed", 1)'
expect_red "STATUS.md not naming a next session" "$sb" "does not name a next session"

# ---------------------------------------------------------------------------
# 6. a started lab with no NEGATIVE_CONTROL.md must be red
# ---------------------------------------------------------------------------
sb="$(sandbox lab-without-nc)"
mkdir -p "$sb/labs/99-selftest-lab"
printf 'def test_placeholder():\n    assert True\n' > "$sb/labs/99-selftest-lab/test_thing.py"
expect_red "a started lab with no negative control" "$sb" "no NEGATIVE_CONTROL.md"

# ---------------------------------------------------------------------------
# 7. a duplicated session number must be red
# ---------------------------------------------------------------------------
sb="$(sandbox duplicate)"
cp "$sb/docs/sessions/S-000-init.md" "$sb/docs/sessions/S-000-copy.md"
expect_red "a duplicated session number" "$sb" "duplicate session numbers"

# ---------------------------------------------------------------------------
printf '\n'
if [ "$fail" -ne 0 ]; then
  printf 'session selftest FAILED (%d passed, %d failed)\n' "$pass" "$fail"
  exit 1
fi
printf 'session selftest passed (%d mutations, all detected)\n' "$pass"
