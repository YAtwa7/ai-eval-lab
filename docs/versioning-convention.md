# Versioning convention

Decision (2026-10-22): ai-eval-lab tracks a **single semantic version**,
with a brief of what was done recorded for every release — and the depth
of that brief is as descriptive as the importance of the version.

## Decisions

| Decision | Choice |
| --- | --- |
| Where the version lives | Root `VERSION` (plain text, one line) as the single source of truth; per-release briefs in `CHANGELOG.md`, newest first |
| How releases are made | `scripts/bump.sh major\|minor\|patch "brief" [-t]` — increments `VERSION`, inserts the entry in the right format, optionally commits and tags |
| Numbering vs the course program | Single semver track: `0.x` while the eval harness and labs are being built; `1.x` when the nine labs and the CI gate are complete. The version never resets |
| Tags | `vX.Y.Z` (script's `-t` flag commits `VERSION` + `CHANGELOG.md` and creates the tag) |

## Brief depth scales with importance

| Bump | Means | Brief format | Enforced by `bump.sh` |
| --- | --- | --- | --- |
| **Major** `X.0.0` | Program complete, breaking structure change | Full write-up: summary paragraph, what changed & why, new/removed pieces, how to verify | Minimum 120 chars |
| **Minor** `X.Y.0` | New capability or documentation milestone | Short intro line + 3–6 bullets | Minimum 20 chars |
| **Patch** `X.Y.Z` | Fix or tidy | Single line | Max 100 chars, no newlines |

The strictness is intentional: a one-word major brief makes the milestone
useless later, and a paragraph-long patch note drowns the history.

## Release workflow

1. Do the work; keep commits conventional (one topic per commit).
2. Run the bump with a brief at the right depth:
   `scripts/bump.sh minor "Short intro to the change"`.
3. Review `VERSION` and the new `CHANGELOG.md` entry.
4. Commit version + changelog (`bump.sh -t` does this and tags in one go).

Agents working in this repo follow this same rule: before ending a session
that includes substantive work, propose the appropriate bump and brief
rather than leaving the version state ambiguous.

## Versioning the eval datasets

Separately from the repo version, **golden datasets carry their own version**
(`dataset_version` inside the dataset file). The two are not the same thing:

- The repo version moves when the *code* changes.
- The dataset version moves when the *definition of good* changes.

A dataset re-baseline is a minor bump at minimum, and the release brief
must say what changed in the definition of good and why.
