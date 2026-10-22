# agents/ — runbooks and prompts

Agent-facing material for this repo. Anything an agent needs to do its job
that is *not* repo documentation belongs here: role briefs, spawn prompts,
runbooks.

| File | Role |
| --- | --- |
| [`qa-prover.md`](qa-prover.md) | The QA-PROVER runbook: how to spawn the reviewer and what it must report |
| [`pipeline-steward.md`](pipeline-steward.md) | The PIPELINE-STEWARD runbook: CI failure triage ("watchdog" trigger), the reaction loop, what it may never do |

The reviewer's **criteria** live in [`docs/PROVER.md`](../docs/PROVER.md);
this folder holds the *how to run it* layer. Keep the two in step — if the
criteria change, change the runbook's pointer, not a second copy of the
rules.

## Conventions for anything added here

- **A prompt that spawns a sub-agent must carry its own context.**
  Sub-agents start empty, so every spawn prompt states the task, the
  requirement, and the memory scope below.
- **Memory scope is explicit.** Sub-agents must be told to search mem0 in the
  `ai-eval-lab` scope with
  `filters: {"AND": [{"user_id": "ai-eval-lab"}]}` before non-trivial work,
  and to report durable facts they learn back to the calling session.
  Without the explicit filter the hosted server returns empty results
  silently.
- **Repo over memory.** If a memory contradicts `README.md`, `docs/`, or
  `CHANGELOG.md`, the repo wins.
- **No secrets in prompts.** Never paste credentials, tokens, or `.env.local`
  values into a runbook or a sub-agent prompt.
- **Plain ASCII in shell snippets.** Non-ASCII gets mangled by Windows
  shells; keep commands copy-pasteable. Arabic text belongs in data files
  under `evals/datasets/`, never in a shell heredoc.
