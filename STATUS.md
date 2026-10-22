# STATUS — where we stand

> This file is rewritten at the end of every session. It is the first thing a
> cold chat reads after `AGENTS.md`. Keep it to one screen.
> **Last updated:** 2026-10-22 · **Session:** S-000 (init)

## Position

Repo scaffolded. Conventions layer, session protocol, and the course map are
in place. No course work has started. Next session opens C1.

**Next session: S-001 - C1 Module 0-1: observability and tracing** - start
from `docs/COURSE-MAP.md` C1, read `courses/C1-langchain-reliable-agents/NOTES.md`
for the reading order, then work `labs/01-tracing/`. The first thing to
produce is the agent skeleton in `apps/agent_service/` and a tracing eval in
`labs/01-tracing/` with a recorded negative control. Nothing from C1 has been
read yet, so there is nothing to unlearn.

## What exists

| Piece | State |
| --- | --- |
| Repo + CI + gate | done (`scripts/check-conventions.sh` green) |
| Session protocol | done (`docs/SESSION-PROMPT.md`, `docs/sessions/README.md`) |
| Course map (the three courses) | done (`docs/COURSE-MAP.md`) |
| Curriculum + 12-session roster | done (`CURRICULUM.md`) |
| Course notes + quiz banks | scaffolded, empty (`courses/C1..C3`) |
| Labs 01-09 | scaffolded (BRIEF.md only) |
| Apps (rag_service, agent_service, multi_tenant_api) | placeholder |
| Eval harness | placeholder |
| mem0 scope `ai-eval-lab` | seeded with the durable decisions |

## Open threads

- **S-001** - C1 Module 0-1 (observability, tracing, analyzing your agent).
  Produces `apps/agent_service/` skeleton + `labs/01-tracing/`.
- **Credentials are provisioned and verified.** `verify.py` passes end to
  end: a live Gemini `generateContent` (HTTP 200, real reply) and live
  LangSmith read + write against the **EU** endpoint
  `https://eu.api.smith.langchain.com`. Two things worth knowing before
  S-001:
  - The **Gemini free tier returns transient HTTP 503 "high demand"** - it
    took two retries to get a 200. Any provider call in the harness must
    retry on 503/429, or the eval suite will be flaky for a reason that has
    nothing to do with the thing under test.
  - `gemini-2.5-flash` is **no longer available to new accounts**;
    `gemini-3.8-flash` is the working default, `gemini-flash-latest` the
    alias fallback.
- **The LangSmith account is on the EU region.** Service-level calls
  (`/info`) succeed against either host, but every tenant-scoped call
  returns 403 on the US host - which reads exactly like a permissions
  problem. `LANGSMITH_API_URL` is set in `.env.local`.
- **`langchain-community` is pinned to 0.3.31** in `requirements.txt` on
  purpose: 0.4.x removed `chat_models.vertexai`, which `ragas` imports at
  module load, so `import ragas` breaks. Do not bump it without a
  clean-venv import check.
- **The venv is built** at `.venv` with the full pinned set.
- **Phoenix not yet started.** C2's labs need `arize-phoenix` running
  locally (`phoenix serve`); it is 100% free to self-host and needs no key.
- **Screening call notes not yet recorded.** If the user shares what the
  Ghaia.ai screener actually asked, re-tune the C1/C2 emphasis and pre-write
  `docs/interview/Q&A.md` against their questions rather than the written JD.

## Deliberately deferred

- **C3** (LangChain *Intro to Agent Observability & Evaluations*, 43 lessons,
  7.5h video) is planned as S-008/S-009. C1 already covers
  datasets/evaluators/experiments; C3's unique value is Module 4 (annotation
  queues), which S-010 (judge calibration) depends on. That is why C3 sits
  immediately before S-010 rather than later.
- **The $99 LCAE exam.** Free practice exam and the free prerequisite bundle
  are the study path; the paid exam only once a Ghaia-shaped role is live.
