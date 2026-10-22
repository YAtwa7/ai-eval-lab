# CURRICULUM — courses, sessions, labs

> The progress bar. A ticked box is a session that produced a handoff, a
> commit, and a recorded negative control. Maintained by every session; the
> gate checks that the session numbering and the session files agree.
>
> Course links, durations, and certificate mechanics:
> [`docs/COURSE-MAP.md`](docs/COURSE-MAP.md).

**Legend** — `[ ]` planned · `[~]` in progress · `[x]` complete
**Builder** — who writes the code this session: `tutor` (built with the
tutor, you direct) · `you` (you build, the tutor coaches and reviews) ·
`both` (read + quiz together, build in the session)

---

## Courses

| Code | Course | Provider | Time | Cert |
| --- | --- | --- | --- | --- |
| **C1** | Building Reliable Agents with LangSmith | LangChain Academy | 29 lessons, reading-based | completion certificate |
| **C2** | Evaluating AI Agents | DeepLearning.AI + Arize AI | 2h36m + 5 labs | completion certificate + graded assignment |
| **C3** | Intro to Agent Observability & Evaluations | LangChain Academy | 43 lessons, 7.5h video | completion certificate |

---

## Sessions

### C1 — LangChain Academy, *Building Reliable Agents with LangSmith*

- [ ] **S-001** · `both` · C1 M0-1 · Observability, tracing, analyzing your agent → `labs/01-tracing/`
- [ ] **S-002** · `both` · C1 M2 · Evaluating agents: datasets, experiments, code-based / LLM-as-judge / pairwise → `labs/02-golden-dataset/`, `labs/03-judge/`
- [ ] **S-003** · `both` · C1 M3 · Moving to production: insights agent, online evals, automations → `labs/08-ci-gate/`

### C2 — DeepLearning.AI, *Evaluating AI Agents*

- [ ] **S-004** · `tutor` · C2 L1 · Evaluation in the time of LLMs, decomposing agents, building the agent → `apps/agent_service/`
- [ ] **S-005** · `tutor` · C2 L2-3 · Tracing your agent, router and skill evaluations → `labs/01-tracing/`, `labs/04-component-evals/`
- [ ] **S-006** · `tutor` · C2 L4-5 · Trajectory evaluations, convergence score, structured experiments → `labs/05-trajectory-evals/`
- [ ] **S-007** · `tutor` · C2 L6+ · Improving your LLM-as-judge, monitoring agents, graded assignment → `labs/02-golden-dataset/`, `labs/03-judge/`, `docs/CERTIFICATES.md`

### C3 — LangChain Academy, *Intro to Agent Observability & Evaluations*

- [ ] **S-008** · `both` · C3 M1-2 · Tracing, datasets, evaluators, experiments (fast pass — C1 covered the core) → consolidation notes
- [ ] **S-009** · `both` · C3 M3-5 · Prompt Hub, human feedback + annotation queues, production observability → `labs/09-monitoring/`

### Standalone labs — the differentiating work

- [ ] **S-010** · `you` · Judge calibration · 100 human labels, agreement %, threshold from data → `labs/06-judge-calibration/`
- [ ] **S-011** · `you` · Bilingual EN/AR + RTL · Arabic golden set, RTL render checks, Arabic safety classes → `labs/07-bilingual-rtl/`
- [ ] **S-012** · `you` · Red team + interview readiness · injection / tenant-leak / hallucination, final CI gate, the five rehearsed answers → `labs/08-ci-gate/`

---

## Labs

| Lab | Covers | JD clause it answers | Sessions |
| --- | --- | --- | --- |
| `labs/01-tracing/` | Tracing an agent; turn a trace into a test case | "add observability... know how to debug it" | S-001, S-005 |
| `labs/02-golden-dataset/` | Versioned golden cases; trace → dataset | "golden datasets and LLM-as-judge" | S-002, S-007 |
| `labs/03-judge/` | Judge rubric, pairwise vs pointwise | "choosing the appropriate evaluator" | S-002, S-007 |
| `labs/04-component-evals/` | Router decisions, skill correctness | "score agent responses, tool use" | S-005 |
| `labs/05-trajectory-evals/` | Trajectory scoring, convergence | "evaluate non-deterministic multi-agent behavior" | S-006 |
| `labs/06-judge-calibration/` | Human-labeled calibration set, agreement | "LLM-as-judge" — the hard clause | S-010 |
| `labs/07-bilingual-rtl/` | EN/AR golden set, RTL rendering, Arabic safety | "bilingual (English/Arabic) and RTL" | S-011 |
| `labs/08-ci-gate/` | Score regression fails the build | "catch regressions when models, prompts, workflows change" | S-003, S-012 |
| `labs/09-monitoring/` | Production trace analysis, online evals, dashboards | "monitor agent quality in production" | S-009 |

---

## Systems under test

| App | Purpose | Built in |
| --- | --- | --- |
| `apps/rag_service/` | FastAPI RAG service, EN + AR corpus, tenant-aware retrieval | S-001 |
| `apps/agent_service/` | LangGraph tool-using agent with router and skills | S-004 |
| `apps/multi_tenant_api/` | Tenant isolation + RBAC — the target for leak tests | S-011 |

---

## Toolchain

| Concern | Choice | Note |
| --- | --- | --- |
| Python | 3.13 (`python3 -m venv .venv`) | mirrors sentinel-qa; no `uv` |
| Generator + judge | Gemini free tier | Groq / OpenRouter free models as fallbacks; Ollama offline |
| Observability | LangSmith (free Developer tier, 5k traces/mo) · Phoenix (self-hosted, free) · Langfuse (self-hosted, free) | three options, one provider interface |
| Eval frameworks | Ragas · DeepEval · Promptfoo · Giskard | all OSS |
| CI | GitHub Actions | conventions gate + eval gate |
| Cost | **$0** | optional $99 LCAE exam only |
