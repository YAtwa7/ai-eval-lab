#!/usr/bin/env bash
# scripts/bump.sh — release a new version of ai-eval-lab.
#
# Usage:
#   scripts/bump.sh <major|minor|patch> "brief" [-t]
#
# The brief's depth must scale with the importance of the bump
# (see docs/versioning-convention.md):
#   patch — one line, <= 100 chars
#   minor — short intro + bullets, >= 20 chars
#   major — >= 120 chars: summary, what & why, how to verify
#
# Options:
#   -t  also commit VERSION + CHANGELOG.md and create git tag vX.Y.Z

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION_FILE="$ROOT/VERSION"
CHANGELOG="$ROOT/CHANGELOG.md"

level="${1:-}"
brief="${2:-}"
tag=no
if [ "${3:-}" = "-t" ]; then tag=yes; fi

if [ -z "$level" ]; then
  echo "usage: scripts/bump.sh <major|minor|patch> \"brief\" [-t]" >&2
  exit 1
fi
if [ -z "$brief" ]; then
  echo "error: a brief describing what was done is required" >&2
  exit 1
fi
case "$level" in
  major|minor|patch) ;;
  *) echo "error: level must be major, minor, or patch (got: $level)" >&2; exit 1 ;;
esac

# --- enforce the importance-scaled brief rules ------------------------------
len=${#brief}
case "$level" in
  major)
    if [ "$len" -lt 120 ]; then
      echo "error: a major bump needs a descriptive brief (>= 120 chars, got $len)." >&2
      echo "       cover: summary, what changed & why, how to verify." >&2
      exit 1
    fi ;;
  minor)
    if [ "$len" -lt 20 ]; then
      echo "error: a minor brief needs at least 20 chars (got $len)." >&2
      exit 1
    fi ;;
  patch)
    if [ "$(printf '%s' "$brief" | wc -l)" -gt 1 ]; then
      echo "error: a patch brief must be a single line." >&2
      exit 1
    fi
    if [ "$len" -gt 100 ]; then
      echo "error: a patch brief is one line (<= 100 chars, got $len)." >&2
      exit 1
    fi ;;
esac

# --- read + bump version -----------------------------------------------------
cur="$(tr -d '[:space:]' < "$VERSION_FILE")"
case "$cur" in
  [0-9]*.[0-9]*.[0-9]*) ;;
  *) echo "error: $VERSION_FILE does not contain a semver like 0.1.0 (got: $cur)" >&2; exit 1 ;;
esac
ma="${cur%%.*}"
rest="${cur#*.}"
mi="${rest%%.*}"
pa="${rest#*.}"

case "$level" in
  major) ma=$((ma + 1)); mi=0; pa=0 ;;
  minor) mi=$((mi + 1)); pa=0 ;;
  patch) pa=$((pa + 1)) ;;
esac
new="$ma.$mi.$pa"

# Build the entry (patch = single line; minor/major = heading + body)
date="$(date +%F)"
if [ "$level" = "patch" ]; then
  entry="## [$new] — $date — $brief"
else
  entry="## [$new] — $date"$'\n\n'"$brief"
fi

# Validate the changelog has the marker BEFORE touching VERSION,
# so a failure can't leave half a release behind.
if ! grep -q '<!-- entries-below -->' "$CHANGELOG"; then
  echo "error: $CHANGELOG is missing the <!-- entries-below --> marker" >&2
  exit 1
fi

printf '%s\n' "$new" > "$VERSION_FILE"
export BUMP_ENTRY="$entry"
tmp="$(mktemp)"
awk '
  { print }
  /<!-- entries-below -->/ { print ""; print ENVIRON["BUMP_ENTRY"] }
' "$CHANGELOG" > "$tmp" && mv "$tmp" "$CHANGELOG"

# keep the "Current version" line in sync
sed_tmp="$(mktemp)"
sed "s/^Current version: .*$/Current version: **$new**/" "$CHANGELOG" > "$sed_tmp" \
  && mv "$sed_tmp" "$CHANGELOG"

echo "bumped $cur -> $new"
if [ "$tag" = "yes" ]; then
  git -C "$ROOT" add VERSION CHANGELOG.md
  git -C "$ROOT" commit -m "Release $new"
  git -C "$ROOT" tag "v$new"
  echo "committed and tagged v$new"
else
  echo "remember to commit VERSION and CHANGELOG.md (or rerun with -t)"
fi
