# ai-eval-lab

A study lab for **AI Eval QA** — the discipline of making non-deterministic
LLM systems assertable. Golden datasets, LLM-as-judge, RAGAS / DeepEval /
Promptfoo / LangSmith, red-teaming, bilingual EN/AR evaluation, and CI gates
that fail a build when quality regresses.

Built as a **portfolio artifact** and a **study program** at the same time.

## The idea

Traditional pass/fail testing does not survive a non-deterministic agent. The
question stops being "did it work?" and becomes "did it work *well enough*,
*consistently*, and *can I prove that*?" That needs a different toolset:

| Instead of | You need |
| --- | --- |
| assertions | golden datasets + versioned expected cases |
| exact match | code-based metrics, LLM-as-judge, human calibration |
| a green test run | a scorecard with thresholds, diffed against a baseline |
| a passing build | an eval gate that fails on regression |
| a bug report | a trace, a trajectory, a reproducible dataset |

Every technique here is paired with a **negative control** — proof that the
check fired red for the right reason. A check that has never failed proves
nothing.

## The target role this was built for

A Senior QA Engineer role at an agentic-AI platform: owning QA strategy
across a web app, a backend control plane, an agent SDK, and a notification
service; building evaluation harnesses that score agent responses, tool use,
and RAG retrieval quality; probing for prompt injection, tenant leakage, and
hallucination; testing bilingual EN/AR and RTL experiences; and owning
quality gates and go/no-go decisions.

The course map ([`docs/COURSE-MAP.md`](docs/COURSE-MAP.md)) and the
curriculum ([`CURRICULUM.md`](CURRICULUM.md)) map every session to the
clause of that role it answers.

## How this repo is worked

**One session = one chat = one unit of work.** A chat is a context window
with a hard limit, not a container for state. So:

- The **repo** holds the state: `STATUS.md`, `CURRICULUM.md`, and one
  handoff file per session in `docs/sessions/`.
- Each **session** gets a fresh chat, bootstrapped from
  [`docs/SESSION-PROMPT.md`](docs/SESSION-PROMPT.md).
- The previous session's **handoff** is how a cold chat resumes.

The gate enforces it: session numbers must be contiguous, every handoff must
carry all required sections, and `STATUS.md` must name the next session. A
second script proves those rules can still fail, by mutating a scratch copy
of the repo once per rule.

```sh
scripts/progress.sh          # observed progress across courses, sessions, labs
scripts/check-conventions.sh # the gate - run it before every PR
```

**Handing the program to a fresh chat:** paste
[`docs/STUDY-PROTOCOL.md`](docs/STUDY-PROTOCOL.md) — it is self-contained
and explains the structure, the rules, and how progress moves.

## Layout

| Path | What lives there |
| --- | --- |
| `apps/` | Systems under test: RAG service, agent service, multi-tenant API |
| `evals/` | Harness: golden datasets, judge rubrics, metric wrappers, runner |
| `labs/` | Nine numbered exercises, each with its own brief and negative control |
| `courses/` | Per-course notes and quiz results — the study artifact |
| `docs/` | Course map, eval strategy, session protocol, interview Q&A |
| `docs/sessions/` | One handoff per session — the continuity mechanism |
| `scripts/` | The gate, the progress reporter, the release helper |

## Setup

```sh
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
cp .env.example .env.local     # add your keys here; never commit it
```

Requires Python 3.13. The eval frameworks are pinned and all declare 3.13
support.

**Credentials.** [`.env.example`](.env.example) is the single place that
says which key goes where, where to get it, and which session needs it. The
short version: you need **one** model provider key to start — `GEMINI_API_KEY`
(free tier, no card) is the recommended one. LangSmith is needed by S-001
(free Developer tier); Phoenix and Langfuse are self-hosted and need no key
at all.

Paste keys with the helper rather than an editor — it prints the length, so
a truncated paste is visible immediately instead of surfacing later as an
opaque 403:

```sh
scripts/set-key.sh GEMINI_API_KEY
scripts/set-key.sh LANGSMITH_API_KEY
```

The reason there are several providers rather than one: **the judge should
not be the same model as the generator.** Self-preference bias inflates
scores, and being able to point the judge at a different provider is the
cheapest defense. Set Gemini for generation and Groq (or OpenRouter) for
judging, and say so in your write-up.

## Cost

**$0.** Every framework used here is open source (Ragas, DeepEval, Promptfoo,
Giskard, Phoenix, Langfuse), LangSmith has a free Developer tier, and the
model providers used have free tiers. The only optional spend in the whole
program is the $99 LangChain Certified Agent Engineer exam.

## Conventions

| Doc | What it fixes |
| --- | --- |
| [`AGENTS.md`](AGENTS.md) | Read-chain, session doctrine, working agreements, memory scope |
| [`STATUS.md`](STATUS.md) | Where we stand — rewritten every session |
| [`CURRICULUM.md`](CURRICULUM.md) | Courses, sessions, labs, and their checkboxes |
| [`docs/SESSION-PROMPT.md`](docs/SESSION-PROMPT.md) | The bootstrap for every new session chat |
| [`docs/STUDY-PROTOCOL.md`](docs/STUDY-PROTOCOL.md) | The whole program in one paste-able block — hand this to a cold chat |
| [`docs/PROTOCOL-TEMPLATE.md`](docs/PROTOCOL-TEMPLATE.md) | Blank template to adopt the same method in **another** project |
| [`docs/sessions/README.md`](docs/sessions/README.md) | The handoff template and session index |
| [`docs/COURSE-MAP.md`](docs/COURSE-MAP.md) | The three courses, verified links, certificate mechanics |
| [`docs/EVAL-STRATEGY.md`](docs/EVAL-STRATEGY.md) | How to choose a metric, set a threshold, design a judge |
| [`docs/JUDGE-CALIBRATION.md`](docs/JUDGE-CALIBRATION.md) | Calibrating a judge against human labels |
| [`docs/PROVER.md`](docs/PROVER.md) | Reviewer criteria |
| [`docs/versioning-convention.md`](docs/versioning-convention.md) | Bump levels and brief depth |
| [`INCIDENTS.md`](INCIDENTS.md) | Every bug leaves a prevention rule with a regression test |

**Working agreements:** evidence over assertion · a check must be able to
fail · every eval ships a negative control · tests are part of "done" · every
bug gets an `INCIDENTS.md` entry · never commit secrets, tokens, or PII.

## Privacy

This repo is public. Keys live only in `.env.local` (gitignored). Fixtures,
snapshots, traces, and eval reports are repo surface too — keep them clean.
Eval outputs can embed source content; `evals/reports/` is gitignored for
that reason.

## License

PolyForm Noncommercial License 1.0.0 — see [`LICENSE`](LICENSE). Noncommercial
use is permitted: read it, learn from it, fork it. Commercial use is not.
