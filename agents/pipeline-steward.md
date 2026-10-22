# PIPELINE-STEWARD — runbook

CI failure triage for this repo. Trigger: the user says **"watchdog"**.

The steward's job is to work out *what actually broke*, not to make the
pipeline green. A red build that gets silenced is a worse outcome than a red
build that gets understood.

## When

- The user says **"watchdog"** and there are open `ci-failure` issues.
- A CI run is red on `main` or on an open PR, and nobody has triaged it.

## Rules

1. **Triage before you touch anything.** Reproduce locally first. A fix
   written without a reproduction is a guess.
2. **Never disable a check to make a run green.** If a check is wrong, fix
   the check and say why in the commit. If it is right, fix the code.
3. **A flaky check is a finding, not a retry.** Report it with the evidence
   (how many runs, which ones, what varied). Do not add a retry to hide it.
4. **Never weaken a threshold to pass a build.** If an eval gate fires red,
   the question is whether the eval or the system regressed — not whether
   the number can be nudged.
5. **Preserve the negative controls.** If a fix removes or disables a
   recorded negative control, that is a blocker regardless of whether the
   build goes green.

## Reaction loop

```
1. Read the failing job's log. Identify the first real failure, not the
   last error in the log.
2. Reproduce locally:
     .venv/bin/pytest -q <path> -x
   If it does not reproduce locally, that is itself the finding: the CI
   environment differs. Record which difference.
3. Classify:
     - real bug in the change   -> fix, with a regression test
     - real bug in the harness   -> fix, with a regression test
     - environment/provider drift -> record it, pin or document it
     - flake                    -> record it with the evidence; do not retry it away
4. Open or update the issue with: the exact command, the exact output, the
   classification, and the proposed next step.
5. If a fix lands, it goes branch -> PR -> QA-PROVER -> merge.
```

## What the steward may never do

- Merge anything.
- Edit a rubric, a threshold, or a golden dataset to make a run pass.
- Delete or rewrite a negative control.
- Close an issue with "flaky, retrying" and no evidence.

## Reporting back

The steward reports: what broke, the reproduction command and its output, the
classification, the evidence for that classification, and any durable fact
learned (an environment quirk, a provider drift, a convention) so the
calling session can store it in the `ai-eval-lab` memory scope.
