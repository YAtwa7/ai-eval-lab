# AGENTS.md

Instructions for agents working in this repo (OpenCode or otherwise). Read the
repo first — `README.md` is the entry point.

**Last updated:** 2026-10-22 · **Current version:** v0.1.0

## Read-chain (every session, in order)

1. `AGENTS.md` (this file)
2. `STATUS.md` — where we stand right now
3. `CURRICULUM.md` — courses, labs, and their checkboxes
4. `docs/sessions/` — read the highest-numbered `S-*.md`; **that file is your
   handoff**
5. `docs/SESSION-PROMPT.md` — the session protocol
6. `docs/STUDY-PROTOCOL.md` — the whole program, if you need the full picture
7. `git log --oneline -10`

Then search cross-session memory (below) before non-trivial work.

## Session doctrine

This repo is a **study lab**: one chat per session, state in the repo.

- **One session = one chat = one unit of work.** A chat is a context window
  with a hard limit, not a container for state. Study sessions never continue
  in an old chat; they start fresh from the handoff.
- **The repo is the state.** If a session ends without a handoff file, it did
  not happen — the next chat cannot read the conversation.
- **Roles.** MAIN (hub: status, dispatch, docs ownership) · BUILDER-<item>
  (one session per unit of work, then stops) · QA-PROVER (review-only;
  runbook in `agents/qa-prover.md`, criteria in `docs/PROVER.md`).
- **Triggers.** The user says **"status"** → report from the files only, not
  from recollection. The user says **"rotate"** → flush the roadmap, push, list
  the open loops. The user says **"watchdog"** → triage the open
  `ci-failure` issues per `agents/pipeline-steward.md`.
- **Docs go direct to `main`; code goes branch → PR → QA-PROVER → merge.**
- **The repo is canonical.** If a memory contradicts the repo, the repo wins
  — and update the repo doc if the memory reflects a real change.

## Project pointers

| Thing | Location |
| --- | --- |
| Entry point / what this repo proves | `README.md` |
| Where we stand | `STATUS.md` |
| Courses, labs, and progress | `CURRICULUM.md` |
| The three courses under study | `docs/COURSE-MAP.md` |
| Certificates earned and where to claim them | `docs/CERTIFICATES.md` |
| How to build an eval (metrics, thresholds, judge design) | `docs/EVAL-STRATEGY.md` |
| Judge calibration method | `docs/JUDGE-CALIBRATION.md` |
| Reviewer brief (criteria) | `docs/PROVER.md` |
| Session protocol + paste-in bootstrap | `docs/SESSION-PROMPT.md` |
| The whole program in one paste-able block | `docs/STUDY-PROTOCOL.md` |
| Session handoff template | `docs/sessions/README.md` |
| Versioning rule | `docs/versioning-convention.md` |
| Release history | `CHANGELOG.md` (+ git tags `vX.Y.Z`) |
| Current version | `VERSION` |
| Postmortems | `INCIDENTS.md` |
| The gate | `scripts/check-conventions.sh` |
| Session-integrity checks | `scripts/session-check.sh` |
| Observed progress | `scripts/progress.sh` |
| Releases | `scripts/bump.sh major\|minor\|patch "brief" [-t]` |
| CI | `.github/workflows/ci.yml` |

## Working agreements

1. **Code: branch → PR → QA-PROVER → merge.** Never push code to `main`
   directly. Docs changes may go direct to `main`.
2. **Evidence over assertion.** Report the command you ran and its output. A
   green badge, a screenshot, or a prose summary is a claim to verify.
3. **A check must be able to fail.** For a fix, show the negative control:
   with the fix reverted (or the check disabled) it fails, with the fix
   applied it passes. A test that cannot fail proves nothing.
4. **Every eval ships a negative control.** An eval that has never fired red
   for the right reason proves nothing. Record the command, the mutation, and
   the red output in the lab's `NEGATIVE_CONTROL.md`.
5. **Tests are part of "done"** — including a regression test for every bug,
   in the same change as the fix.
6. **Every bug gets an `INCIDENTS.md` entry** ending in a generalizable
   prevention rule that a future reviewer can apply from the diff alone.
7. **Never commit secrets, tokens, credentials, or PII.** Keys live in
   `.env.local` only. Fixtures, snapshots, traces and logs are repo surface
   too — keep them clean. This repo is public.
8. **Don't mask flakiness with retries.** Retries are reported; a spec that
   only passes on retry is a finding about stability.
9. **Keep docs current in the same change.** A ticked curriculum box, an
   updated status line, or a new incident is part of the work.
10. **Shell snippets stay plain ASCII** — non-ASCII breaks some shells and
    editors. Arabic text belongs in data files under `datasets/`, never in a
    shell heredoc.
11. **Quiz every course session.** Each session ends with three questions from
    `courses/<course>/QUIZ.md`. The quiz is the training; the code is
    secondary.

## Cross-session memory (mem0 MCP)

Agents/chats share learned context through a memory layer (Mem0, exposed as
MCP tools: `add_memory`, `search_memories`, `get_memories`,
`get_event_status`).

- **Scope:** project memories live under `user_id: "ai-eval-lab"`. Do not
  store without an explicit `user_id`; do not rely on `agent_id` (the hosted
  MCP server drops it when `user_id` is set).
- **Search/read:** every read (`search_memories`, `get_memories`) must pass an
  explicit scope filter —
  `filters: {"AND": [{"user_id": "ai-eval-lab"}]}`. Without one, the hosted
  server injects a default user scope that matches nothing and silently
  returns empty results — treat empty output as a filter slip, not as missing
  memories.
- **Read habit:** at session start, search this scope before non-trivial work;
  act on memories instead of re-deriving facts.
- **Write:** store only durable, learned facts — decisions, thresholds,
  why a metric was rejected, environment quirks, troubleshooting lessons. Never
  store secrets, credentials, or `.env` values. Writes are async — after
  `add_memory`, poll `get_event_status` until it reports `SUCCEEDED`.
- **Sub-agents:** start with no context. Any prompt that spawns a sub-agent
  must instruct it to search this memory scope first and to report durable
  facts it learns back to the calling session.
- **Precedence:** this repository is canonical. If a memory disagrees with the
  repo, the repo wins.

## Where things live

| Thing | Location |
| --- | --- |
| Systems under test (RAG service, agent, multi-tenant API) | `apps/` |
| Eval harness (providers, judges, metrics, runner) | `evals/` |
| Golden datasets | `evals/datasets/golden/` |
| LLM-as-judge rubrics | `evals/judges/` |
| Per-lab exercises | `labs/NN-*/` |
| Course notes and quiz results | `courses/CN-*/` |
| Interview Q&A | `docs/interview/Q&A.md` |
| Resume bullets (measured only) | `docs/PORTFOLIO.md` |
