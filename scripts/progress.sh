#!/usr/bin/env bash
# scripts/progress.sh -- observed progress for ai-eval-lab.
#
# Reads CURRICULUM.md, docs/sessions/ and the labs directory and prints one
# screen: how far the courses have got, which session is next, and how many
# labs carry a recorded negative control.
#
# This is a REPORT, not a gate: it always exits 0. The gate is
# scripts/check-conventions.sh.
#
# Usage: scripts/progress.sh

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CURRICULUM="$ROOT/CURRICULUM.md"
SESSIONS="$ROOT/docs/sessions"

# ---------------------------------------------------------------------------
# session state
# ---------------------------------------------------------------------------
session_files="$(find "$SESSIONS" -maxdepth 1 -type f -name 'S-*.md' 2>/dev/null | sort)"
total_sessions="$(printf '%s\n' "$session_files" | grep -c . || true)"
[ -z "$session_files" ] && total_sessions=0

done_sessions="$(grep -l '^status: *complete' $session_files 2>/dev/null | wc -l | tr -d ' ')"
partial_sessions="$(grep -l '^status: *partial' $session_files 2>/dev/null | wc -l | tr -d ' ')"
blocked_sessions="$(grep -l '^status: *blocked' $session_files 2>/dev/null | wc -l | tr -d ' ')"

next_session="$(grep -m1 -E 'Next session:[[:space:]]*S-[0-9]{3}' "$ROOT/STATUS.md" 2>/dev/null \
  | sed -E 's/.*Next session:[[:space:]]*(S-[0-9]{3}).*/\1/')"

# ---------------------------------------------------------------------------
# per-course progress, parsed from CURRICULUM.md
# ---------------------------------------------------------------------------
bar() {
  # bar <done> <total> <width>
  local done="$1" total="$2" width="${3:-10}"
  local filled=0
  if [ "$total" -gt 0 ]; then
    filled=$(( done * width / total ))
  fi
  local i=0 s=""
  while [ "$i" -lt "$width" ]; do
    if [ "$i" -lt "$filled" ]; then s="${s}#"; else s="${s}-"; fi
    i=$((i + 1))
  done
  printf '%s' "$s"
}

course_line() {
  # course_line <label> <section-marker>
  local label="$1" marker="$2"
  local total done n line=""
  total="$(awk -v m="$marker" '
    $0 ~ m { inblock=1; next }
    inblock && /^### / { inblock=0 }
    inblock && /^- \[[ x~]\] \*\*S-[0-9]{3}\*\*/ { c++ }
    END { print c+0 }' "$CURRICULUM")"
  done="$(awk -v m="$marker" '
    $0 ~ m { inblock=1; next }
    inblock && /^### / { inblock=0 }
    inblock && /^- \[x\] \*\*S-[0-9]{3}\*\*/ { c++ }
    END { print c+0 }' "$CURRICULUM")"
  if [ "$total" -eq 0 ]; then
    printf '  %-34s [ not planned ]\n' "$label"
  else
    printf '  %-34s [%s] %d/%d sessions\n' "$label" "$(bar "$done" "$total")" "$done" "$total"
  fi
}

printf '\n'
printf 'ai-eval-lab - observed progress\n'
printf '===============================\n\n'

printf 'Courses\n'
course_line "C1 LangChain Reliable Agents" '^### C1 '
course_line "C2 DLAI Evaluating AI Agents" '^### C2 '
course_line "C3 LangChain Observability" '^### C3 '
course_line "Standalone labs" '^### Standalone labs'

printf '\nSessions\n'
printf '  %d of %d complete' "$done_sessions" "$total_sessions"
if [ "$partial_sessions" -gt 0 ]; then printf ', %d partial' "$partial_sessions"; fi
if [ "$blocked_sessions" -gt 0 ]; then printf ', %d blocked' "$blocked_sessions"; fi
printf '\n'
if [ -n "$next_session" ]; then
  printf '  next: %s\n' "$next_session"
fi

# ---------------------------------------------------------------------------
# labs + negative controls
# ---------------------------------------------------------------------------
if [ -d "$ROOT/labs" ]; then
  labs_total=0
  nc_ok=0
  labs_started=0
  for dir in "$ROOT/labs"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    case "$name" in __pycache__) continue ;; esac
    labs_total=$((labs_total + 1))
    content="$(find "$dir" -type f -not -name 'BRIEF.md' -not -name 'README.md' \
      -not -path '*/__pycache__/*' -not -name '*.pyc' | head -n 1)"
    [ -z "$content" ] && continue
    labs_started=$((labs_started + 1))
    [ -f "$dir/NEGATIVE_CONTROL.md" ] && nc_ok=$((nc_ok + 1))
  done
  printf '\nLabs\n'
  printf '  %d defined, %d started\n' "$labs_total" "$labs_started"
  printf '  negative controls: %d/%d started labs\n' "$nc_ok" "$labs_started"
fi

# ---------------------------------------------------------------------------
# last commit
# ---------------------------------------------------------------------------
last="$(git -C "$ROOT" log --oneline -1 2>/dev/null || true)"
if [ -n "$last" ]; then
  printf '\nLast commit\n  %s\n' "$last"
fi

printf '\n'
