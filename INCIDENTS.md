# INCIDENTS.md

Every bug that lands here leaves a **prevention rule** that a future
reviewer can apply from the diff alone, backed by a regression test that
fails against the old code.

Format: symptom -> root cause -> fix -> **prevention rule**.

---

## Template

```markdown
## INC-NNN: <one-line symptom>

**Symptom:** what was observed, with the command and output.

**Root cause:** why it happened.

**Fix:** what changed.

**Prevention rule:** the generalizable rule, stated so a reviewer can apply
it to a diff they have never seen.

**Regression test:** <path to the test> - it fails against the old code.
```

---

## Entries

_None yet. The first entry is filed when the first eval or harness bug is
found. An eval that has never fired red proves nothing - and the first time
one fires for the wrong reason is exactly when this file gets its first
entry._
