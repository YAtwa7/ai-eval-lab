# STUDY PROTOCOL — the full program, in one paste-able block

This is the canonical explanation of how the study program works. It is
written so it can be handed to **any fresh chat** with no prior context,
and that chat will understand the program, the rules, and where things
stand.

For the short per-session bootstrap, use [`SESSION-PROMPT.md`](SESSION-PROMPT.md).
This document is the *why* and the *whole picture*; that one is the *do*.

---

## The block

Copy everything below into a new chat.

```text
PROJECT: ai-eval-lab - a study lab for AI Eval QA.

REPO: /Users/joey/GitHub/ai-eval-lab  (public, github.com/YAtwa7/ai-eval-lab)
MEMORY SCOPE: user_id "ai-eval-lab". Every mem0 read must pass the explicit
filter {"AND":[{"user_id":"ai-eval-lab"}]}. Without it the hosted server
silently returns empty results. The repo always wins over memory.

=== WHAT THIS PROGRAM IS ===

Goal: become able to execute AI-evaluation work as a senior/lead QA
engineer for an agentic AI platform - specifically to score non-deterministic
LLM and agent behaviour (golden datasets, LLM-as-judge, RAG retrieval quality,
tool use, trajectory scoring), catch regressions in CI, and red-team for
prompt injection, tenant leakage and hallucination.

It is a study program AND a portfolio artifact. Twelve sessions across three
free certified courses, producing a public repo that demonstrates the
discipline end to end.

=== THE ONE RULE ===

One study session = one chat = one unit of work.

A chat is a context window with a hard limit, not a container for state.
So the REPO holds the state; the chat holds only what matters right now.
Never continue a study session in an old chat - start fresh from the
previous session's handoff. If a session ends without a handoff file, it did
not happen: the next chat cannot read the conversation.

=== READ-CHAIN (every session, in this order) ===

1. AGENTS.md                     - the conventions and the working agreements
2. STATUS.md                     - where we stand right now (one screen)
3. CURRICULUM.md                 - courses, sessions, labs, checkboxes
4. docs/sessions/                - read the HIGHEST-numbered S-*.md.
                                   That file IS your handoff.
5. docs/SESSION-PROMPT.md        - the session protocol
6. git log --oneline -10
7. mem0 search (scope ai-eval-lab, explicit filter)

=== WRITE-CHAIN (every session ends like this, in order) ===

1. Write docs/sessions/S-NNN-<slug>.md from the template in
   docs/sessions/README.md. Every section is required.
2. Update STATUS.md (it is rewritten each session) and tick the
   CURRICULUM.md box.
3. Update courses/<course>/NOTES.md; append Q&A to courses/<course>/QUIZ.md.
4. Record the negative control: the exact command, the mutation applied, and
   the red output - in the lab's NEGATIVE_CONTROL.md.
5. Commit. Docs go direct to main. Code goes branch -> PR -> review -> merge.
6. Store durable facts to mem0 scope "ai-eval-lab"; poll get_event_status
   until SUCCEEDED before treating a memory as stored.
7. Report back: what changed, evidence (commands + output), what the next
   session does, and any durable fact learned.

=== HOW PROGRESS MOVES ===

Progress is four files, and they must agree:

- CURRICULUM.md      the plan and the checkboxes. A ticked box = a session
                     that produced a handoff, a commit, and a recorded
                     negative control.
- STATUS.md          the present. One screen. Names the next session.
- docs/sessions/     the history. One handoff per session, append-only.
                     S-000 is the repo init; the study sessions are
                     S-001 .. S-012.
- scripts/progress.sh  the observed view. Run it any time; it reads the
                     files and prints courses, sessions, next session, labs
                     started, and negative-control coverage.

The gate (scripts/check-conventions.sh) fails if those files disagree:
a gap in the session numbering, a handoff missing a template section, a
STATUS.md that does not name the next session, or a lab holding real content
without a NEGATIVE_CONTROL.md. scripts/session-selftest.sh proves those
rules can still fail by mutating a scratch copy of the repo eight times.

Sessions never run out of order. The next session is always whatever
STATUS.md and the newest handoff agree on.

=== THE PROGRAM ===

C1  LangChain Academy - "Building Reliable Agents with LangSmith"
    free, 29 lessons, reading-based (no video). Taken FIRST because its
    module list is the job description: observability, tracing, datasets,
    experiments, code-based eval, LLM-as-judge, pairwise eval, online evals,
    automations. It is also the TEST-domain course of the free LCAE
    prerequisite bundle, so nothing is wasted if the $99 exam is taken later.

C2  DeepLearning.AI - "Evaluating AI Agents" (with Arize AI)
    free, 2h36m plus five runnable labs. The lab notebooks are public and
    Arize Phoenix is 100% free to self-host, so these labs run locally with
    no API key. This is the most runnable course in the set.

C3  LangChain Academy - "Intro to Agent Observability & Evaluations"
    free, 43 lessons, 7.5h video. DEFERRED to S-008/S-009: C1 already
    covers datasets/evaluators/experiments, so C3 is a fast pass plus the
    parts C1 lacks - prompt hub, human feedback and annotation queues, and
    production monitoring. Its annotation-queue module is what the judge
    calibration lab needs, which is why C3 sits right before it.

Sessions, with who builds the code:
  S-001..S-003  C1, read + quiz together, build in the session
  S-004..S-007  C2, worked through together; the labs run locally
  S-008..S-009  C3, fast pass plus reference
  S-010..S-012  THE DIFFERENTIATORS - the human builds, the tutor coaches
                S-010 judge calibration (100 human labels, agreement %,
                        threshold from data)
                S-011 bilingual EN/AR + RTL (Arabic corpus, Arabic-calibrated
                        rubric, RTL rendering checks)
                S-012 red team + final CI gate + the five rehearsed
                        interview answers

Why that split: a portfolio the candidate cannot defend is worth nothing in
a lead-level interview, and building all twelve solo burns out before
session three. So the tooling labs are built together and rehearsed, and
the three labs nobody else in the candidate pool will have are owned by the
human.

=== RULES THE TUTOR FOLLOWS ===

1. One session, one unit of work. If the assignment grows, log it in the
   handoff as a thread for a later session rather than expanding now.
2. Demand a negative control before anything merges. An eval that has never
   fired red proves nothing.
3. Quiz at the end of every course session, three questions from
   courses/<course>/QUIZ.md. The quiz is the training; the code is
   secondary. Ask the questions and wait for the answer.
4. Evidence over assertion: report the command and its output, never a
   prose summary of what you believe happened.
5. Repo over memory. If they disagree, the repo wins - and if the memory
   reflects a real change, update the repo doc.
6. Never commit secrets. Keys live in .env.local only.
7. Every bug gets an INCIDENTS.md entry ending in a generalizable prevention
   rule, with a regression test.
8. Code goes branch -> PR -> QA-PROVER -> merge. Docs go direct to main.
9. Report back durable facts so the calling session can store them in the
   ai-eval-lab memory scope. Do not store secrets.
10. Do not expand scope to "while I'm here". A session that does two
    things has done neither.

=== RULES THE HUMAN FOLLOWS ===

1. Bring your own model credentials in .env.local (gitignored). Never paste
   a key into a chat or a commit.
2. Answer the quiz out loud, then write the answer in the quiz file. An
   answer you have only read is not an answer you have.
3. Write REFLECTION.md in your own words - what you built, why you chose it,
   what was fuzzy. That file is the interview material.
4. Show up with the course section read. The session is not a lecture.
5. Flag a broken session early rather than letting it drift: a partial
   handoff with a clear "Next session" line is more useful than a silent stop.

=== COST AND CREDENTIALS ===

Total cost $0. Gemini free tier is the default generator and judge, with
Groq and OpenRouter free models as fallbacks and Ollama for offline, all
behind one provider interface so the judge can differ from the generator.
Every framework used is open source. The only optional spend in the whole
program is the $99 LangChain Certified Agent Engineer exam (free practice
exam first). No certificate is claimed before it is issued and verifiable -
see docs/CERTIFICATES.md.

=== IF YOU ARE THE TUTOR FOR SESSION S-NNN ===

Fill in the assignment and continue. The assignment is stated in the newest
handoff under "Next session". Follow the read-chain, do the work, then
follow the write-chain exactly, in order. End by asking the three quiz
questions and by reporting what the next session should do.
```

---

## Why the protocol is a protocol and not a suggestion

Three of the rules are enforced mechanically, because a rule nobody checks
is a suggestion:

| Rule | Enforced by |
| --- | --- |
| Session numbering has no gaps; every handoff has every section; `STATUS.md` names the next session | `scripts/session-check.sh` |
| A lab with real content has a recorded negative control | `scripts/session-check.sh` |
| The rules above still match anything | `scripts/session-selftest.sh` |

The selftest matters most. Without it, "the gate is green" and "the gate
stopped matching anything" look identical — and the second one is how a
convention rots without anyone noticing. The selftest mutates a scratch
copy of the repo once per rule and asserts the gate goes red **for the
stated reason**, because a negative control that goes red for the wrong
reason is not a control.

It already earned its place: during S-000 it caught that the
required-sections list was silently collapsed by a backslash-continued
string assignment (the rule matched nothing and reported success), and that
`sed -i ''` is macOS-only and would have broken the selftest on the
`ubuntu-latest` CI runner.

## Related

| Doc | What it holds |
| --- | --- |
| [`SESSION-PROMPT.md`](SESSION-PROMPT.md) | The short per-session bootstrap |
| [`sessions/README.md`](sessions/README.md) | The handoff template and session index |
| [`../AGENTS.md`](../AGENTS.md) | The conventions and working agreements |
| [`../CURRICULUM.md`](../CURRICULUM.md) | The plan and the progress bar |
| [`../STATUS.md`](../STATUS.md) | Where we stand |
| [`COURSE-MAP.md`](COURSE-MAP.md) | The courses, verified links, certificate mechanics |
| [`EVAL-STRATEGY.md`](EVAL-STRATEGY.md) | How to design an eval |
| [`JUDGE-CALIBRATION.md`](JUDGE-CALIBRATION.md) | How to trust a judge |
| [`PROVER.md`](PROVER.md) | The reviewer's criteria |
