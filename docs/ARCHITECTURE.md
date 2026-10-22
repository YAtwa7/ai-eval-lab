# ARCHITECTURE — how ai-eval-lab is put together

## What this repo is

A study lab and portfolio artifact for **AI Eval QA**: making
non-deterministic LLM systems assertable. It is not a product. There is no
user, no deployment, no customer. What it *is* is a body of work that
demonstrates the discipline end to end — golden datasets, calibrated judges,
trajectory scoring, red-teaming, bilingual evaluation, and CI gates that
fail a build on regression.

## The load-bearing decision: the repo is the state

The central architectural choice is **where state lives**.

This is a study program, and a study program has an unusual property: the
*work* is cognitive (reading, understanding, being able to answer questions
about it), while the *evidence* is code and files. A chat transcript is
neither — it is ephemeral, unbounded, and unreadable by the next chat.

So the rule is:

> **One session = one chat = one unit of work. The repo holds the state; the
> chat holds only what matters right now.**

Everything else follows from that:

| Concern | Mechanism | Why not the obvious alternative |
| --- | --- | --- |
| Where am I? | `STATUS.md` | Chat history is not addressable by a cold reader |
| What is left? | `CURRICULUM.md` checkboxes | A progress bar in prose drifts |
| What did the last session decide? | `docs/sessions/S-NNN-*.md` | The transcript is gone when the chat ends |
| What is durable and not in the repo? | mem0 scope `ai-eval-lab` | Memory is the wrong place for anything the repo can hold |
| Did the convention survive? | `scripts/session-check.sh` | A convention nobody checks is a suggestion |

The gate enforcing session integrity is the piece that makes the convention
real rather than aspirational. A gap in the session numbering, a handoff
missing a section, a `STATUS.md` that does not name the next session, or a
lab with real content but no recorded negative control — each is a hard
failure in CI.

## Layers

```
                 +----------------------------------------------+
   session       |  docs/sessions/S-NNN-*.md   (one per session)  |
   (one chat)    |  STATUS.md  CURRICULUM.md                    |
                 +--------------------+-------------------------+
                                      |  handoff + checkpoints
                                      v
   study         +----------------------------------------------+
   artifact      |  courses/CN-*/{NOTES.md, QUIZ.md}             |
                 +--------------------+-------------------------+
                                      |  what the course said
                                      v
   harness       +----------------------------------------------+
   (reusable)    |  evals/{datasets, judges, metrics, harness}  |
                 +--------------------+-------------------------+
                                      |  measures
                                      v
   system under  +----------------------------------------------+
   test          |  apps/{rag_service, agent_service,           |
                 |        multi_tenant_api}                     |
                 +--------------------+-------------------------+
                                      |  gates on
                                      v
   evidence      +----------------------------------------------+
                 |  labs/NN-*/{BRIEF.md, tests/, golden/,        |
                 |          judges/, NEGATIVE_CONTROL.md}         |
                 +----------------------------------------------+
```

Each layer points down. The session layer writes the study artifact and
ticks the curriculum; the study artifact justifies the harness; the harness
measures the apps; the labs hold the evidence; the gate checks the whole
stack for integrity.

## The apps are not decoration

It is tempting to treat `apps/` as scaffolding. It is not. An eval harness
with nothing to evaluate is a vocabulary exercise. The three apps exist so
that every metric has a real subject:

| App | Why it exists |
| --- | --- |
| `apps/rag_service/` | RAG metrics (faithfulness, context precision/recall) need a retriever with a corpus and a tenant dimension. Bilingual EN/AR is where most eval frameworks fall over. |
| `apps/agent_service/` | Trajectory and tool-use scoring need an agent that routes, calls skills, and takes a variable number of steps. |
| `apps/multi_tenant_api/` | Tenant-leak and isolation tests need an actual isolation boundary to probe, with role-based access to vary. |

They are small, and they are deliberately modelled on the target stack:
FastAPI, WebSockets, multi-tenancy, RBAC, RAG, and an English/Arabic corpus
with RTL rendering.

## Provider abstraction

Every LLM call goes through one interface (`evals/harness/providers.py`)
with a single interface and swappable backends: Gemini free tier by
default, Groq and OpenRouter free models as fallbacks, Ollama for offline.

Two reasons, both of them learned the hard way in eval work:

1. **A judge must not be the same model as the generator.** Self-preference
   bias is real and it inflates scores. Being able to point the judge at a
   different provider is the cheapest defense.
2. **Free tiers differ across providers and change.** Pinning one provider
   makes the harness brittle; the interface makes a swap a config change.

## Evidence rules

Three rules govern anything that claims a result:

1. **A check must be able to fail.** Every eval ships a
   `NEGATIVE_CONTROL.md` recording the exact command, the mutation applied,
   and the red output. An eval that has never fired red proves nothing.
2. **Evidence over assertion.** A report states the command and its output.
   A green badge or a prose summary is a claim to verify, not evidence.
3. **Repo over memory.** If a memory contradicts the repo, the repo wins.

## What is built vs planned

| Piece | State |
| --- | --- |
| Conventions layer, gate, session protocol, course map | **built** (S-000) |
| Curriculum, 12-session roster, lab briefs | **built** (S-000) |
| Eval harness, apps, labs | **planned** — S-001 onward |
| Judge calibration, bilingual eval, red team | **planned** — S-010 .. S-012 |

The repo deliberately ships with an empty harness and populated briefs. The
first thing a reviewer should notice is that the *structure* is honest about
what exists.

## Where to look first

| Question | File |
| --- | --- |
| What is this and why? | `README.md` |
| Where do we stand? | `STATUS.md` |
| What is left? | `CURRICULUM.md` |
| What is the plan, and why these three courses? | `docs/COURSE-MAP.md` |
| How do I run a session? | `docs/SESSION-PROMPT.md` |
| How do I design an eval? | `docs/EVAL-STRATEGY.md` |
| How do I trust the judge? | `docs/JUDGE-CALIBRATION.md` |
| What does "done" mean here? | `docs/PROVER.md` |
