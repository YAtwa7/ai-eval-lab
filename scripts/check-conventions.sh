#!/usr/bin/env bash
# scripts/check-conventions.sh -- the gate for ai-eval-lab.
#
# Runs in CI (.github/workflows/ci.yml) and locally before opening a PR.
# It checks the convention layer, which is what this repo promises before any
# eval code exists:
#
#   1. VERSION is semver and agrees with CHANGELOG.md (current line + newest entry)
#   2. the CHANGELOG keeps the <!-- entries-below --> marker
#   3. every relative link in a tracked markdown file resolves
#   4. no secret-shaped file is tracked by git
#   5. the required convention files are present
#   6. session integrity (delegates to scripts/session-check.sh)
#   7. the session gate's own selftest (scripts/session-selftest.sh)
#
# Plain ASCII on purpose - non-ASCII breaks some shells and editors.
#
# Usage: scripts/check-conventions.sh   (exit 0 = pass, exit 1 = fail)

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
failed=0
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

ok()  { printf 'ok    %s\n' "$1"; }
bad() { printf 'FAIL  %s\n' "$1"; failed=1; }

# ---------------------------------------------------------------------------
# 1. VERSION
# ---------------------------------------------------------------------------
version=""
if [ -f "$ROOT/VERSION" ]; then
  version="$(tr -d '[:space:]' < "$ROOT/VERSION")"
  if printf '%s' "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    ok "VERSION is semver ($version)"
  else
    bad "VERSION is not semver: '$version'"
  fi
else
  bad "VERSION file is missing"
fi

# ---------------------------------------------------------------------------
# 2. CHANGELOG agrees with VERSION
# ---------------------------------------------------------------------------
CHANGELOG="$ROOT/CHANGELOG.md"
if [ -f "$CHANGELOG" ]; then
  if grep -q '<!-- entries-below -->' "$CHANGELOG"; then
    ok "CHANGELOG keeps the <!-- entries-below --> marker"
  else
    bad "CHANGELOG is missing the <!-- entries-below --> marker (bump.sh needs it)"
  fi

  if [ -n "$version" ]; then
    if grep -qF "Current version: **$version**" "$CHANGELOG"; then
      ok "CHANGELOG 'Current version' matches VERSION"
    else
      bad "CHANGELOG 'Current version' does not match VERSION ($version)"
    fi

    newest="$(grep -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$CHANGELOG" | head -n 1 | tr -d '#[] ')"
    if [ -z "$newest" ]; then
      bad "CHANGELOG has no release heading (## [X.Y.Z])"
    elif [ "$newest" = "$version" ]; then
      ok "newest CHANGELOG entry is $version"
    else
      bad "newest CHANGELOG entry is '$newest' but VERSION is '$version'"
    fi
  fi
else
  bad "CHANGELOG.md is missing"
fi

# ---------------------------------------------------------------------------
# 3. relative links in markdown resolve
# ---------------------------------------------------------------------------
# Work from the working tree, not `git ls-files`: an untracked doc must fail
# the gate locally before it is ever committed (a new file is exactly where
# dead links come from).
md_files="$(
  cd "$ROOT" && find . -name '*.md' \
    -not -path './.git/*' \
    -not -path '*/node_modules/*' \
    -not -path './.venv/*' \
    -not -path '*/dist/*' \
    -not -path '*/coverage/*' \
    -not -path './.opencode/*' \
  | sed 's|^\./||'
)"

checked_links=0
old_ifs="$IFS"
IFS='
'
for rel in $md_files; do
  file="$ROOT/$rel"
  [ -f "$file" ] || continue
  dir="$(dirname "$file")"
  targets="$(grep -oE '\]\([^()]*\)' "$file" | sed -E 's/^\]\((.*)\)$/\1/' || true)"
  for target in $targets; do
    case "$target" in
      http://*|https://*|mailto:*|tel:*|\#*) continue ;;
    esac
    path="${target%%#*}"   # drop the anchor
    path="${path%% *}"     # drop an optional title
    path="${path#<}"
    path="${path%>}"
    [ -n "$path" ] || continue
    case "$path" in
      /*) full="$ROOT$path" ;;
      *)  full="$dir/$path" ;;
    esac
    checked_links=$((checked_links + 1))
    if [ ! -e "$full" ]; then
      printf '%s -> %s\n' "$rel" "$target" >> "$TMP"
    fi
  done
done
IFS="$old_ifs"

if [ -s "$TMP" ]; then
  bad "dead relative links in docs"
  sed 's/^/      /' "$TMP"
else
  ok "markdown links resolve ($checked_links checked)"
fi

# ---------------------------------------------------------------------------
# 4. secret hygiene
# ---------------------------------------------------------------------------
tracked="$(git -C "$ROOT" ls-files 2>/dev/null || true)"
if [ -n "$tracked" ]; then
  secret_files="$(
    printf '%s\n' "$tracked" \
      | grep -E '(^|/)\.env$|(^|/)\.env\.[A-Za-z0-9_.-]+$' \
      | grep -v '\.env\.example$' || true
  )"
  key_files="$(
    printf '%s\n' "$tracked" \
      | grep -Ei '\.(pem|key|p12|pfx|jks|keystore)$' || true
  )"
  found="$(printf '%s\n%s\n' "$secret_files" "$key_files" | grep -v '^$' || true)"
  if [ -n "$found" ]; then
    bad "secret-shaped files are tracked by git"
    printf '%s\n' "$found" | sed 's/^/      /'
  else
    ok "no secret-shaped files tracked (.env*, *.pem, *.key, ...)"
  fi
else
  ok "git metadata unavailable - skipped the secret scan"
fi

# ---------------------------------------------------------------------------
# 5. required convention files
# ---------------------------------------------------------------------------
missing=""
for required in \
  VERSION CHANGELOG.md README.md AGENTS.md LICENSE INCIDENTS.md \
  CURRICULUM.md STATUS.md \
  docs/ARCHITECTURE.md docs/ROADMAP.md docs/PROVER.md docs/COURSE-MAP.md \
  docs/EVAL-STRATEGY.md docs/JUDGE-CALIBRATION.md docs/CERTIFICATES.md \
  docs/SESSION-PROMPT.md docs/STUDY-PROTOCOL.md docs/PROTOCOL-TEMPLATE.md \
  docs/versioning-convention.md \
  docs/sessions/README.md \
  scripts/bump.sh scripts/session-check.sh scripts/session-selftest.sh scripts/progress.sh
do
  [ -e "$ROOT/$required" ] || missing="$missing $required"
done
if [ -n "$missing" ]; then
  bad "required convention files are missing:$missing"
else
  ok "required convention files are present"
fi

# ---------------------------------------------------------------------------
# 6. session integrity
# ---------------------------------------------------------------------------
if [ -x "$ROOT/scripts/session-check.sh" ] || [ -f "$ROOT/scripts/session-check.sh" ]; then
  if bash "$ROOT/scripts/session-check.sh"; then
    ok "session integrity checks passed"
  else
    bad "session integrity checks failed"
  fi
else
  bad "scripts/session-check.sh is missing"
fi

# ---------------------------------------------------------------------------
# 7. the session gate's own selftest
# ---------------------------------------------------------------------------
# Proves the session rules can actually fail. Without this, "the gate is
# green" could mean "the gate stopped matching anything" - which is exactly
# the failure mode that lets a convention rot unnoticed. Cheap (about a
# second), so it runs on every gate invocation, locally and in CI.
if [ -f "$ROOT/scripts/session-selftest.sh" ]; then
  if bash "$ROOT/scripts/session-selftest.sh"; then
    ok "session gate selftest passed"
  else
    bad "session gate selftest failed"
  fi
else
  bad "scripts/session-selftest.sh is missing"
fi

# ---------------------------------------------------------------------------
printf '\n'
if [ "$failed" -ne 0 ]; then
  printf 'conventions check FAILED\n'
  exit 1
fi
printf 'conventions check passed\n'
