# COURSE MAP — the three courses under study

Verified live on **2026-10-22**. Every link below returned HTTP 200 and the
stated duration, lesson count, and certificate mechanism were read off the
page, not estimated.

**Why these three:** they are the free, certificate-bearing courses whose
syllabus matches the target role's hardest paragraphs. Together they cover
golden datasets, LLM-as-judge, code-based evaluators, pairwise comparison,
trajectory scoring, experiments, and production monitoring.

---

## C1 — LangChain Academy: Building Reliable Agents with LangSmith

🔗 **https://academy.langchain.com/courses/building-reliable-agents**

| | |
| --- | --- |
| Provider | LangChain Academy |
| Cost | **Free** |
| Format | 29 lessons, **0 hours of video** (reading + platform work) |
| Certificate | Completion certificate (LangChain Academy ships a student-certificate page; exact issuance text is behind sign-in — confirm on first login) |
| Exam link | This course is the **TEST domain** of the LCAE prerequisite bundle |

### Why this one first

Its module list *is* the job description:

| Module | Lessons | Job-description clause it covers |
| --- | --- | --- |
| 0. Getting Started | setup | — |
| 1. Observation | Observability · Tracing with LangSmith · Analyzing your Agent | "add observability to your agent to gain insights into its steps and know how to debug it" |
| 2. Evaluation | Evaluating Agents · Creating Datasets · Running Experiments · **Eval 1 Code-based** · **Eval 2 LLM-as-a-Judge** · **Eval 3 Pairwise** | "build evaluation harnesses and regression suites that score agent responses, tool use, and RAG retrieval quality (e.g., golden datasets and LLM-as-judge)" |
| 3. Moving Towards Production | Moving Towards Production · Insights Agent · **Online Evals** · **Automations** | "evaluation pipelines that continuously measure agent quality and catch regressions when models, prompts, or workflows change" |

### Lab mapping

- **S-001** → `labs/01-tracing/`, `apps/agent_service/` skeleton
- **S-002** → `labs/02-golden-dataset/`, `labs/03-judge/`
- **S-003** → `labs/08-ci-gate/` (draft)

### Requirements

A free LangSmith account (Developer tier: $0/seat, up to 5k base traces/month,
then pay-as-you-go). Platform exercises need it; the reading half does not.

---

## C2 — DeepLearning.AI: Evaluating AI Agents

🔗 **https://www.deeplearning.ai/short-courses/evaluating-ai-agents/**

| | |
| --- | --- |
| Provider | DeepLearning.AI, in partnership with **Arize AI** |
| Instructors | John Gilhuly (Head of DevRel), Aman Khan (Director of Product) |
| Cost | **Free** |
| Format | 2h36m video · 15 lessons · 6 code examples · 1 graded assignment |
| Certificate | Completion certificate (per-course graded assignment + certificate unlock on the course page) |

### The five labs (verified lesson titles)

1. **Lab 1: Building your agent** → `apps/agent_service/`
2. **Lab 2: Tracing your agent** → `labs/01-tracing/`
3. **Lab 3: Adding router and skill evaluations** → `labs/04-component-evals/`
4. **Lab 4: Adding trajectory evaluations** → `labs/05-trajectory-evals/`
5. **Lab 5: Adding structure to your evaluations** (convergence score, experiments) → `labs/05-trajectory-evals/`

Plus two lecture segments that map onto their own sessions: *Improving your
LLM-as-a-judge* (S-007) and *Monitoring agents* (S-007).

### Why it is the most runnable course

- **The lab code is public.** Community mirrors of the official notebooks
  exist (e.g. `ksm26/Evaluating-AI-Agents` — `L3/L5/L7/L9/L11.ipynb`).
- **Arize Phoenix is 100% free to self-host** (verified:
  `arize.com/docs/phoenix/self-hosting` → "100% Free"). Run `phoenix serve`
  locally and the tracing labs work end-to-end with no API key and no cost.

### Lab mapping

- **S-004** → `apps/agent_service/` real build
- **S-005** → `labs/01-tracing/`, `labs/04-component-evals/`
- **S-006** → `labs/05-trajectory-evals/`
- **S-007** → `labs/02-golden-dataset/`, `labs/03-judge/`, certificate recorded in `docs/CERTIFICATES.md`

---

## C3 — LangChain Academy: Intro to Agent Observability & Evaluations

🔗 **https://academy.langchain.com/courses/intro-to-langsmith**

| | |
| --- | --- |
| Provider | LangChain Academy |
| Cost | **Free** |
| Format | 43 lessons · **7.5 hours of video** |
| Certificate | Completion certificate |
| Status | **Deferred** — planned as S-008/S-009 |

### Why it is deferred, not dropped

C1 already covers datasets, evaluators, and experiments, so C3's first two
modules are a fast consolidation pass (S-008). Its unique value is
**Module 4: Collecting Human Feedback** — *User Feedback*, *Annotation
Queues* — which is precisely the mechanism S-010 (judge calibration) needs to
label 100 cases. That is why C3 sits immediately before S-010 rather than
after it.

| Module | Lessons | Lab mapping |
| --- | --- | --- |
| 1. Visibility While Building with Tracing | Tracing Basics · Types of Runs · Alternative Ways to Trace · Conversational Threads | S-008 (fast pass) |
| 2. Testing and Evaluation | Datasets · Evaluators · Experiments · Analyzing Experiment Results | S-008 (fast pass) |
| 3. Prompt Engineering | Playground · Prompt Hub · Prompt Engineering Lifecycle · Polly | S-009 |
| 4. Collecting Human Feedback | User Feedback · **Annotation Queues** | S-009 → feeds S-010 |
| 5. Production Observability | Filtering · **Online Evaluation** · **Automations** · Monitoring · Custom Dashboards | S-009 → `labs/09-monitoring/` |

---

## The credential on top: LangChain Certified Agent Engineer (LCAE)

🔗 Exam page: **https://academy.langchain.com/pages/certifications-lcae**
🔗 Free practice exam: **https://academy.langchain.com/courses/lcae-practice-exam**
🔗 Free prerequisite bundle: **https://academy.langchain.com/bundles/lcae-prerequisite-courses**

| | |
| --- | --- |
| Cost | **$99 USD** |
| Format | **120 minutes** (~135 min seat time), online proctored (Talview) |
| Certificate | Issued by **Accredible** within 72 hours of passing, by email |
| Retakes | One free resit; further attempts are re-purchased |
| Expiry | None |
| Domains | Build · Test · Deploy · Monitor — "the first industry certification covering the entire Agent Development Lifecycle" |

The practice exam is free and mirrors the real structure (Section 1 Build,
Section 2 Test, Section 3 Deploy, Section 4 Monitor). **Take it before
booking the exam.** The free prerequisite bundle is five courses: Intro to
LangChain - Python, Intro to Deep Agents, **Building Reliable Agents with
LangSmith (C1)**, Intro to LangSmith Deployment, Monitoring Production Agents.

**Do not buy the exam yet.** Study first; the free practice exam tells you
where you actually stand.

---

## Runners-up (not on the critical path — take when a gap appears)

| Course | Link | Time | Why |
| --- | --- | --- | --- |
| Red Teaming LLM Applications (Giskard) | `https://www.deeplearning.ai/short-courses/red-teaming-llm-applications/` | 1h39m | prompt injection against chatbots; feeds S-012 |
| MCP: Build Rich-Context AI Apps with Anthropic | `https://www.deeplearning.ai/short-courses/mcp-build-rich-context-ai-apps-with-anthropic/` | 1h58m | the tool protocol; the target stack runs MCP |
| Long-Term Agentic Memory With LangGraph | `https://www.deeplearning.ai/short-courses/long-term-agentic-memory-with-langgraph/` | 1h24m | memory for long-running agents |
| Safe and reliable AI via guardrails | `https://www.deeplearning.ai/short-courses/safe-and-reliable-ai-via-guardrails/` | 1h42m | output validation |
| ChatGPT Prompt Engineering for Developers | `https://www.deeplearning.ai/short-courses/prompt-engineering-for-developers/` | 1h40m | cheapest high-value warm-up |
| HF AI Agents Course | `https://huggingface.co/learn/agents-course/unit0/introduction` | ~15-20h | free certificate of completion; final project is literally *"Create, Test, and Certify Your Agent"* |
| Claude Academy: Building with the Claude API | `https://academy.claude.com/courses/building-with-the-claude-api` | 9h | 67 lessons; includes prompt eval workflows with dataset generation and automated grading |
| Claude Academy: AI capabilities and limitations | `https://academy.claude.com/courses/ai-capabilities-and-limitations` | 3.5h | the mental model behind what evals can and cannot measure |
| ISTQB CT-AI v2.0 | `https://www.istqb.org/certifications/certified-tester-ai-testing` | — | **syllabus + sample exam are free PDFs, no login**; 40 questions, 60 min, pass 29/44; self-study explicitly sanctioned; the exam is paid |

---

## Reference material (not courses — the free hands-on docs)

| Resource | Link | Use |
| --- | --- | --- |
| Arize Phoenix Cookbooks | `https://arize.com/docs/phoenix/learn` | *Iterative Evaluation & Experimentation Workflow*, *Aligning LLM Evals with Human Feedback*, *Using Human Annotations for Eval Driven Development* |
| Ragas metrics | `https://docs.ragas.io/en/stable/concepts/metrics/available_metrics/` | faithfulness, context precision/recall, answer relevancy, tool call accuracy |
| DeepEval metrics | `https://deepeval.com/docs/metrics-introduction` | answer relevancy, faithfulness, hallucination, task completion, argument correctness, trajectory metrics |
| Promptfoo | `https://www.promptfoo.dev/docs/intro/` | assertions; red-team plugins and strategies |
| Langfuse LLM-as-a-Judge | `https://langfuse.com/docs/evaluation/evaluation-methods` | judge methodology |
| LangSmith evaluation | `https://docs.langchain.com/langsmith/evaluation` | datasets, evaluators, experiments |
| Giskard | `https://www.giskard.ai/` | LLM scanning and agentic red teaming |

---

## Certificate caveats (read before claiming anything)

- **DLAI short courses** award a certificate per course (a graded assignment
  plus a certificate unlock on the course page). DLAI's long *Professional
  Certificate* tracks are different: the 26h RAG one audits free but the
  certificate itself requires payment or financial aid. Do not pick a
  Professional Certificate track expecting a free certificate.
- **LangChain Academy** completion certificates: the platform ships a
  student-certificate page, so the mechanism exists; the exact wording is
  behind sign-in. Confirm on the first login and correct this doc if needed.
- **Claude Academy** issues a "Completion badge" (verified on the course
  listings), which is a badge, not an accredited certificate.
- **HF Agents Course** issues a "certificate of completion by completing
  assignments"; a separate formal certification track exists.
- Never claim a certificate on a CV before it is actually issued and
  verifiable.
