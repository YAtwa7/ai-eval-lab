# Session prompt — the bootstrap for every study session

One study session = one chat = one unit of work. The repo holds the state;
the chat holds only what matters right now. This file is the bootstrap you
paste into a **fresh chat** to start a session.

Nothing below is optional. A session that skips the read-chain starts cold;
a session that skips the write-chain loses its work.

## How to use it

1. Copy the block below.
2. Fill in the two angle-bracket lines: the session number and the assignment.
3. Paste into a **new** chat. Never continue a study session in an old chat —
   a long context window is exactly what this convention exists to avoid.
4. The chat reads the previous session's handoff and picks up from there.

## The bootstrap block

```text
You are running study session S-NNN for the ai-eval-lab project.

REPO: /Users/joey/GitHub/ai-eval-lab
MEMORY SCOPE: user_id "ai-eval-lab". Every read must pass
filters {"AND":[{"user_id":"ai-eval-lab"}]} — the hosted mem0 server silently
returns empty results without that explicit filter. Repo wins over memory.

READ IN THIS ORDER before doing anything:
1. AGENTS.md
2. STATUS.md
3. CURRICULUM.md
4. docs/sessions/ — read the highest-numbered S-*.md. That file is your handoff.
5. docs/SESSION-PROMPT.md — the session protocol
6. git log --oneline -10
7. mem0 search: <query>

YOUR ASSIGNMENT THIS SESSION: <fill>
(also stated in the latest handoff under "Next session")

SCOPE DISCIPLINE: one session, one unit of work. If it grows, note it in the
handoff as a thread for a later session rather than expanding now.

WHEN YOU FINISH, in order:
1. Write docs/sessions/S-NNN-<slug>.md from the template in docs/sessions/README.md
2. Update STATUS.md and tick the CURRICULUM.md box
3. Update courses/<course>/NOTES.md; append quiz Q&A to courses/<course>/QUIZ.md
4. Every eval ships a negative control: the command, the mutation, the red output
5. Commit. Docs -> main directly. Code -> branch -> PR -> review -> merge.
6. Store durable facts to mem0 scope "ai-eval-lab" (poll get_event_status until
   SUCCEEDED). Repo wins over memory.
7. Report back: what changed, evidence (commands + output), what the next session
   should do, and any durable fact you learned.
```

## Notes for the person running the session

- **Bring your own model credentials.** Keys live in `.env.local` (gitignored).
  `.env.example` lists the variables. Never paste a key into a chat, a handoff,
  or a commit.
- **If a session ends early**, still write the handoff and set
  `status: partial`. A partial handoff with a clear "Next session" line is
  more useful than a silent stop.
- **If a session is blocked**, set `status: blocked` and put the blocking
  question in "Open threads". The next session should be able to unblock
  without re-deriving the context.
- **The quiz is not optional.** Each course session ends with three questions
  from `courses/<course>/QUIZ.md`. A session that skips the quiz has not
  trained the thing the session was for.
