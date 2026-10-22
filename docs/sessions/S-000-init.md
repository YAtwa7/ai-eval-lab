---
session: S-000
date: 2026-10-22
course: -
lab: -
branch: main
pr: "-"
status: complete
---

## Where we are

`ai-eval-lab` exists as a **public** repository at
`github.com/YAtwa7/ai-eval-lab`, freshly initialised. It contains the
conventions layer, the session protocol, the course map, the twelve-session
roster, nine lab briefs, three app briefs, and the eval harness layout.
**No course has been read and no eval has been built.** The harness and apps
are deliberate placeholders.

The repo is a study lab for AI Eval QA — the discipline of making
non-deterministic LLM systems assertable. Its defining convention is that
**one study session = one chat = one unit of work**, and the repo — not the
conversation — carries the state between sessions. That convention is
mechanically enforced: `scripts/session-check.sh` fails the gate on a
session-numbering gap, a handoff missing a template section, a `STATUS.md`
that does not name the next session, or a lab holding real content without
a recorded negative control.

**A cold reader can start here.** Read `AGENTS.md`, then `STATUS.md`, then
`CURRICULUM.md`, then this file. Nothing else is required.

## What was done

- Created the repo (public) and initialised `main` with `origin` at
  `YAtwa7/ai-eval-lab`.
- **Conventions layer:** `AGENTS.md` (read-chain, session doctrine, eleven
  working agreements, mem0 scope), `CHANGELOG.md`, `INCIDENTS.md`,
  `VERSION` (0.1.0), `LICENSE` (PolyForm Noncommercial, carried over from
  sentinel-qa), `.gitignore`, `.env.example`, `requirements.txt` (exact
  pins), `pyproject.toml` (ruff + pytest config).
- **The gate:** `scripts/check-conventions.sh` — version/changelog sync,
  dead doc links, secret hygiene, required-file presence, a delegation to
  the session checks, and the session gate's own selftest.
  `scripts/session-check.sh` — the six session-integrity checks.
  `scripts/session-selftest.sh` — proves those checks can still fail (eight
  deliberate mutations, each expected to go red for a specific reason).
  `scripts/bump.sh` — the release helper, ported from sentinel-qa.
- **Observed progress:** `scripts/progress.sh` prints courses, sessions, the
  next session, labs started, and negative-control coverage from the files.
- **The session protocol:** `docs/SESSION-PROMPT.md` (the paste-into-a-new-
  chat bootstrap), `docs/sessions/README.md` (the handoff template and the
  session index), `STATUS.md` (one screen, rewritten every session),
  `CURRICULUM.md` (the checkbox progress bar).
- **The course map:** `docs/COURSE-MAP.md` — the three courses with links,
  durations, module-to-lab mapping, certificate mechanics, and the LCAE
  credential on top, plus runners-up and certificate caveats.
- **The method docs, written before the first eval exists:**
  `docs/EVAL-STRATEGY.md` (choosing an evaluator class, deriving
  thresholds, the variance budget, the baseline-diff gate, bilingual
  pitfalls), `docs/JUDGE-CALIBRATION.md` (the 100-case human-labelled
  method, threshold sweep, failure-mode analysis, bias controls),
  `docs/PROVER.md` (reviewer criteria, including eval-specific and
  session-convention checks).
- **Runbooks:** `agents/README.md`, `agents/qa-prover.md` (spawn prompt with
  the memory-scope rule baked in), `agents/pipeline-steward.md`.
- **Scaffolding:** nine lab briefs under `labs/`, each naming the failure it
  detects, the acceptance criteria, and the definition of done; three app
  briefs under `apps/`; the eval harness layout under `evals/`; per-course
  notes and a 33-question quiz bank across `courses/C1..C3`.
- **Portfolio material:** `docs/PORTFOLIO.md` (resume bullets with
  unfilled brackets, the five rehearsed answers, the numbers to have ready)
  and `docs/interview/Q&A.md` (where the answers get written in your own
  words).
- **CI:** `.github/workflows/ci.yml` — the conventions gate on every change,
  and an eval gate that activates once `evals/requirements.txt` lands.

## What was learned (durable)

- **Python 3.13 is safe for this stack.** Verified against PyPI on
  2026-10-22: `deepeval` 4.3.1, `arize-phoenix` 20.24.0, `langsmith`
  0.14.12, `langgraph` 1.2.16, `ragas` 0.4.3, `openai` 3.36.1,
  `google-genai` 2.32.0, `pytest` 9.1.1 all declare 3.13 support. No
  version pinning problem exists.
- **`uv` is not installed on this machine** and no eval package is global.
  The repo therefore mirrors sentinel-qa's convention exactly:
  `python3 -m venv .venv` plus a pinned `requirements.txt`. No new tooling
  and no extra install step.
- **The DLAI "Evaluating AI Agents" lab code is public**, and Arize Phoenix
  is **100% free to self-host** (verified:
  `arize.com/docs/phoenix/self-hosting`). The five labs run locally with no
  API key — which is why C2 is the course that can actually be worked
  through rather than only read.
- **LangChain Academy course pages report "0 hours of video content"** for
  *Building Reliable Agents with LangSmith* — it is reading-and-platform
  work, not video. That makes it the fastest real option, and it is the
  TEST-domain course of the LCAE prerequisite bundle, so it is also the
  best preparation for the $99 exam.
- **The mem0 filter pattern is confirmed working** for a named scope: a read
  of scope `sentinel-qa` with the explicit
  `filters: {"AND": [{"user_id": "sentinel-qa"}]}` returned live memories.
  The `ai-eval-lab` scope is a fresh, empty namespace with identical
  mechanics.
- **Certificate mechanics differ by provider and must not be conflated.**
  DLAI short courses award a per-course certificate (graded assignment plus
  a certificate unlock); DLAI *Professional Certificate* tracks audit free
  but the certificate itself needs payment or financial aid; Claude Academy
  issues a "Completion badge"; LangChain Academy ships a student-certificate
  page but the exact issuance wording is behind sign-in. The LCAE is the
  only proctored, Accredible-issued credential here.
- **The Ghaia.ai JD's hardest paragraph is the eval one** — "build evaluation
  harnesses and regression suites that score agent responses, tool use, and
  RAG retrieval quality (e.g., golden datasets and LLM-as-judge)" plus
  "evaluation pipelines that continuously measure agent quality and catch
  regressions when models, prompts, or workflows change". That paragraph is
  what the three courses were selected for, and it is why C1 outranks the
  more famous 43-lesson course.

## Negative control

n/a - docs and scaffolding only; no eval was implemented this session.

**The gate's own control was run, not asserted.** `scripts/session-selftest.sh`
copies the repo into a scratch directory eight times, applies one deliberate
mutation per session rule, and asserts that the gate turns RED for the stated
reason. Result:

```
ok    control - an unmodified tree passes
ok    gap in the session numbering - detected: session numbering has a gap
ok    a handoff missing a template section - detected: missing section
ok    a handoff missing frontmatter - detected: missing frontmatter key
ok    frontmatter disagreeing with the filename - detected: but the filename says
ok    STATUS.md not naming a next session - detected: does not name a next session
ok    a started lab with no negative control - detected: no NEGATIVE_CONTROL.md
ok    a duplicated session number - detected: duplicate session numbers

session selftest passed (8 mutations, all detected)
```

The selftest found two real bugs in the gate during this session, which is
the point of running it:

1. **The section list was silently broken.** The required-sections list was
   assigned as a backslash-continued string. Because every heading starts
   with `#`, the continuation lines were parsed as part of one quoted word,
   so the list collapsed to a single malformed entry and the rule matched
   nothing. Fixed by using a bash array. The rule was previously a no-op
   that reported success.
2. **`sed -i ''` is macOS-only.** The selftest's own mutations used it, so
   the selftest would have failed on the `ubuntu-latest` CI runner. Fixed by
   doing the mutations in `python3`, which behaves the same on both.

The selftest now runs inside `scripts/check-conventions.sh` on every gate
invocation, and as its own CI job (`session-selftest`), so the proof that
the gate bites is re-established on every push rather than trusted from
this one session.

A third mutation was initially wrong in the test rather than the gate: the
"gap" case hid the only session file, which tripped the "no session files
found" rule instead of the numbering rule. Renaming rather than hiding
produces the mutation the rule was written for. A negative control that
goes red for the wrong reason is not a control, so the selftest asserts on
the specific expected message, not just on a non-zero exit.

## Open threads

- **Next session: S-001 - C1 Module 0-1: observability and tracing** - read
  `courses/C1-langchain-reliable-agents/NOTES.md` for the reading order,
  work `labs/01-tracing/`, and produce the `apps/agent_service/` skeleton.
  Nothing from C1 has been read yet, so there is nothing to unlearn. Start
  from `docs/COURSE-MAP.md` C1, read Modules 0 and 1, then write the first
  trace-based eval.
- **Credentials are not provisioned.** `.env.local` needs a `GEMINI_API_KEY`
  (free tier, from `aistudio.google.com/apikey`) before any judge work in
  S-002. The venv is not built yet either.
- **A free LangSmith account is needed** for C1's platform exercises
  (Developer tier, $0/seat, 5k base traces/month). Sign-up not done.
- **Phoenix is not installed.** C2's labs need `arize-phoenix` running
  locally via `phoenix serve`.
- **Screening-call notes are not recorded.** If the user shares what the
  Ghaia.ai screener actually asked, re-tune the C1/C2 emphasis and
  pre-write `docs/interview/Q&A.md` against their questions rather than
  against the written JD.
- **C3 stays deferred** (planned S-008/S-009) because C1 already covers
  datasets/evaluators/experiments. C3's Module 4 (annotation queues) is
  what S-010 needs, which is why C3 sits immediately before S-010.

## Memory writes

Stored to the `ai-eval-lab` scope (`user_id: "ai-eval-lab"`):

- The three-course selection and the reasoning that put C1 first.
- The toolchain facts: Python 3.13 support confirmed across the eval
  stack; no `uv`; venv plus pinned requirements as the convention.
- The provider model: Gemini free tier primary, Groq and OpenRouter free
  models as fallbacks, Ollama offline, behind one provider interface so the
  judge can differ from the generator.
- The certificate-mechanics caveats by provider.
- The session convention itself: one session per chat, handoff per session,
  gate-enforced contiguity.
- The screening-call gap: what the Ghaia.ai screener asked is not yet
  recorded, and the interview Q&A is aimed at the written JD until it is.
