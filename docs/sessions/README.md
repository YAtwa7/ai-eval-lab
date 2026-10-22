# docs/sessions/ — one file per session, and the handoff template

Every study session writes exactly one file here. The file *is* the handoff:
the next chat cannot read the previous conversation, so this is the only
channel between sessions.

## Naming

```
docs/sessions/S-NNN-<short-slug>.md
```

- `NNN` — zero-padded, three digits, **contiguous, no gaps**. S-000 is the
  repo init. Study sessions run S-001 .. S-012.
- `<short-slug>` — kebab-case, one or two words. `S-005-router-skill-evals.md`.

`scripts/session-check.sh` fails the gate if the numbering has a gap, if a
number is duplicated, or if a session file is missing any required section.

## The template

Copy this into the new session's file. Every section is required — the gate
checks for each heading.

```markdown
---
session: S-007
date: 2026-10-24
course: C2
lab: labs/05-trajectory-evals
branch: feat/trajectory-evals
pr: "#12"
status: complete | partial | blocked
---

## Where we are

One paragraph. The state a fresh chat needs to resume cold, without having
read any earlier session. Assume the reader knows nothing about this project.

## What was done

- Concrete changes, with file paths. Not a summary of intent.

## What was learned (durable)

- Facts that outlive this chat: why a metric was chosen, what a judge got
  wrong, a threshold, an environment quirk.
- These are the lines worth copying into mem0.

## Negative control

- The exact command, the mutation applied, and the red output — or
  "n/a - docs only".
- An eval that has never gone red proves nothing.

## Open threads

- **Next session: S-008 - <title>** - exactly where to start, what not to redo.
- Any deferred work, with the session number it belongs to.

## Memory writes

- What was stored to scope `ai-eval-lab`, and any event ids.
```

## Section rules

| Section | Rule |
| --- | --- |
| `Where we are` | Must let a cold reader continue. No "as discussed". |
| `What was done` | File paths, not intentions. |
| `What was learned (durable)` | Only facts that are not already in the repo. |
| `Negative control` | Command + mutation + red output, or an explicit `n/a`. |
| `Open threads` | Must name the next session number. |
| `Memory writes` | What went to mem0, so a later session can tell a stored fact from a repo fact. |

## The index

The table below is the human-readable session log. `scripts/progress.sh`
regenerates the progress view from `CURRICULUM.md` and this directory.

| Session | Date | Course | Topic | Status |
| --- | --- | --- | --- | --- |
| [S-000](S-000-init.md) | 2026-10-22 | - | repo init, conventions, session protocol | complete |
