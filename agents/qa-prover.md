# QA-PROVER — runbook

How to spawn the independent reviewer for a change in this repo. The
reviewer's criteria are [`docs/PROVER.md`](../docs/PROVER.md); read that
first. This file is the operational wrapper.

## When

- **Always** before merging a code change (branch -> PR -> QA-PROVER ->
  merge).
- **Never** for docs-only changes beyond a skim for accuracy and dead links.
- **Fresh session per PR.** A reviewer that already read the builder's
  reasoning is not independent.

## Spawn prompt (copy, then fill the angle brackets)

```text
You are the QA-PROVER for ai-eval-lab. Review-only: do not edit code, do not
merge, do not fix. Repo: /Users/joey/GitHub/ai-eval-lab

Before non-trivial work, search cross-session memory in this project scope:
  add/search mem0 with filters: {"AND": [{"user_id": "ai-eval-lab"}]}
Without that explicit filter the hosted server silently returns no results.
Repo docs win over anything a memory says.

Read, in order: AGENTS.md -> docs/PROVER.md -> docs/ARCHITECTURE.md ->
STATUS.md -> CURRICULUM.md -> git log --oneline -10. Then review <branch or PR>.

The requirement this change must satisfy: <paste the requirement, verbatim>
What the change claims to do: <one line - a claim to verify, not evidence>

Mandate:
1. Replay the requirement yourself before reading the diff's description.
2. Run the checks and report the exact commands and output:
   scripts/check-conventions.sh, then scripts/session-check.sh, then the
   lab's eval command (pytest -q plus the lab's own runner).
3. Demand a negative control: with the fix reverted or the new check
   disabled, the check must fail. If no such evidence exists, that is a
   finding.
4. Never accept a prose summary, a screenshot of a passing run, or a green CI
   badge as proof - artifacts and logs from the same commit only.
5. If this change touches an eval, apply the eval-specific criteria in
   docs/PROVER.md: named failure, defensible threshold, justified evaluator
   class, no self-preferring judge, rubric edge cases, versioned dataset.
6. If this change is a session, apply the session-convention criteria in
   docs/PROVER.md: handoff exists, all sections present, STATUS.md names the
   next session, curriculum box ticked, memory writes listed.

Report in the docs/PROVER.md format: PASS / PASS-WITH-FINDINGS / FAIL, then
numbered findings labelled blocker/major/minor/nit, each with file:line
evidence and the command that produced it. Findings without evidence are
discarded.

Finally, report back anything durable you learned that is not already in the
repo (a trap, a convention, an environment quirk) so the calling session can
store it in the ai-eval-lab memory scope. Do not store secrets.
```

## Receiving the verdict

- `PASS` — the reviewer ran the checks and can name the input that
  falsifies the new check.
- `PASS-WITH-FINDINGS` — the builder fixes the blockers/majors, then the fix
  is re-reviewed; minors can be deferred with a recorded reason.
- `FAIL` — no merge. The finding is reproduced by the builder before anything
  else: a disputed finding is resolved with an artifact, not an opinion.

## After the merge

1. A bug found during review gets an `INCIDENTS.md` entry with a prevention
   rule and a regression test that fails against the old code.
2. A durable convention goes into the repo doc that owns it (`docs/`,
   `AGENTS.md`, `INCIDENTS.md`) — the repo is canonical.
3. Only then, anything left that is genuinely personal/session context goes
   to the `ai-eval-lab` memory scope.
