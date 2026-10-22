#!/usr/bin/env bash
# scripts/set-key.sh - paste an API key into .env.local without an editor.
#
# WHY THIS EXISTS
#
# A key that is pasted incompletely looks exactly like a key that pasted
# fine. The failure surfaces much later and looks like a permissions
# problem: a truncated LangSmith key returns HTTP 403, which is the same
# response as a key with no access to that resource. A truncated Gemini key
# returns a generic 400. Nothing says "your paste was cut off".
#
# This reads the key without echoing it, writes it in place, and prints the
# length so a truncation is obvious immediately. It also checks the prefix
# against the known format for that provider.
#
# Usage:
#   scripts/set-key.sh GEMINI_API_KEY
#   scripts/set-key.sh LANGSMITH_API_KEY
#
# Expected shapes:
#   GEMINI_API_KEY     AIza...            typically 39 chars
#   LANGSMITH_API_KEY  lsv2_pt_<32>_<32>  typically 72 chars
#
# The key is never printed, never logged, and never committed: it lands in
# .env.local, which is gitignored.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env.local"
VAR="${1:-}"

if [ -z "$VAR" ]; then
  echo "usage: scripts/set-key.sh <VARIABLE_NAME>" >&2
  echo "  e.g. scripts/set-key.sh GEMINI_API_KEY" >&2
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "error: .env.local not found." >&2
  echo "       run: cp .env.example .env.local" >&2
  exit 1
fi

if ! grep -q "^${VAR}=" "$ENV_FILE"; then
  echo "error: $VAR is not a key in .env.example" >&2
  exit 1
fi

echo "Paste the $VAR value below, then press Enter."
echo "(the cursor will stay blank - that is normal, it is not echoing your key)"
printf "%s: " "$VAR"
IFS= read -r KEY
echo

if [ -z "$KEY" ]; then
  echo "error: nothing was pasted" >&2
  exit 1
fi

# strip stray whitespace and wrapping quotes, but keep the value intact
CLEAN="$(printf '%s' "$KEY" | tr -d ' \r' | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")"

python3 - "$ENV_FILE" "$VAR" "$CLEAN" <<'PY'
import sys
path, var, val = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path, "r", encoding="utf-8") as fh:
    lines = fh.read().splitlines()
out = [
    (var + "=" + val) if line.startswith(var + "=") else line
    for line in lines
]
with open(path, "w", encoding="utf-8") as fh:
    fh.write("\n".join(out) + "\n")
PY

LEN=${#CLEAN}
echo "saved $VAR (length $LEN)"

case "$VAR" in
  GEMINI_API_KEY)
    if [ "$LEN" -lt 30 ]; then
      echo "  WARNING: shorter than a normal Gemini key (usually ~39 chars starting AIza)."
      echo "           Most likely truncated - re-copy it from the Google console."
    fi
    case "$CLEAN" in
      AIza*) echo "  format: looks like a Gemini key." ;;
      *)      echo "  WARNING: does not start with AIza - check you copied the API key, not the project id." ;;
    esac
    ;;
  LANGSMITH_API_KEY)
    if [ "$LEN" -lt 65 ]; then
      echo "  WARNING: a full LangSmith key is ~72 chars (lsv2_pt_<32>_<32>)."
      echo "           $LEN chars means it is TRUNCATED - a truncated key returns HTTP 403,"
      echo "           which is indistinguishable from a permissions error."
    fi
    case "$CLEAN" in
      lsv2_*) echo "  format: looks like a LangSmith key." ;;
      *)       echo "  WARNING: does not start with lsv2_ - check you copied the whole key." ;;
    esac
    ;;
  *)
    echo "  (no format check for this variable)"
    ;;
esac
