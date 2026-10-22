# PROTOCOL TEMPLATE — adopt this study structure in another project

This is a **blank template**. Fill the `[angle brackets]` and hand the block
to a chat working on a *different* project, and it will adopt the same
method: one session per chat, state in the repo, a handoff per session, and
a gate that enforces all of it.

**This is not the session-start prompt.** That one lives in
[`SESSION-PROMPT.md`](SESSION-PROMPT.md) and is scoped to one repo's next
session. This one transfers the *method* to a new project.

---

## The block

```text
I want to run a study program in the project below, and I want it to use
the "repo holds the state" convention rather than living in chat history.

PROJECT:        [project name]
REPO:           [absolute path to the repo]
GIT REMOTE:     [owner/name, or "not created yet"]
MEMORY SCOPE:   [memory scope key, e.g. "my-project"]. Every mem0 read must
                pass the explicit filter {"AND":[{"user_id":"<scope>"}]}.
                Without it the hosted server silently returns empty results.
                The repo always wins over memory.

GOAL:           [what the program is meant to make you able to DO, in one
                or two sentences - specific enough to be testable]

COURSES/INPUTS: [the things being studied, each with a link, a length, and
                whether it yields a certificate]

TOTAL SESSIONS: [N]   ONE SESSION = ONE CHAT = ONE UNIT OF WORK

=== THE ONE RULE ===

One study session = one chat = one unit of work.

A chat is a context window with a hard limit, not a container for state. So
the REPO holds the state, and the chat holds only what matters right now.

Never continue a study session in an old chat - start fresh from the
previous session's handoff. If a session ends without a handoff file, it did
not happen: the next chat cannot read the conversation, so the file IS the
context.

This is the whole point. A program that relies on the conversation carrying
state works exactly until the context runs out, and then it silently stops
working.

=== READ-CHAIN (every session, in this order) ===

1. AGENTS.md                - conventions and working agreements
2. STATUS.md                - where we stand right now (one screen)
3. CURRICULUM.md            - the plan: sessions, units of work, checkboxes
4. docs/sessions/           - read the HIGHEST-numbered S-*.md.
                              That file IS your handoff.
5. docs/SESSION-PROMPT.md   - the session protocol
6. git log --oneline -10
7. mem0 search (scope <scope>, explicit filter)

=== WRITE-CHAIN (every session ends like this, in order) ===

1. Write docs/sessions/S-NNN-<slug>.md from the template in
   docs/sessions/README.md. Every section is required.
2. Update STATUS.md (rewritten each session) and tick the CURRICULUM.md box.
3. Update the course/notes file for whatever was studied; append Q&A to the
   matching quiz file.
4. Record the negative control: the exact command, the mutation applied, and
   the red output - in the unit of work's own NEGATIVE_CONTROL.md.
5. Commit. Docs go direct to main. Code goes branch -> PR -> review -> merge.
6. Store durable facts to the memory scope; poll get_event_status until
   SUCCEEDED before treating a memory as stored.
7. Report back: what changed, evidence (commands + output), what the next
   session does, and any durable fact learned.

=== HOW PROGRESS MOVES ===

Progress is four things, and they must agree:

- CURRICULUM.md          the plan and the checkboxes. A ticked box = a
                         session that produced a handoff, a commit, and a
                         recorded negative control.
- STATUS.md              the present. One screen. Names the next session.
- docs/sessions/         the history. One handoff per session, append-only.
                         S-000 is the project init; study sessions follow.
- scripts/progress.sh    the observed view. Reads the files and prints
                         courses/units, sessions, the next session, and
                         negative-control coverage. Run it any time.

The next session is always whatever STATUS.md and the newest handoff agree
on. Sessions never run out of order.

=== ENFORCEMENT (this is the part that makes it a convention) ===

A convention nobody checks is a suggestion. So the rules are made
mechanical, and - this is the part that matters - the checks are proven to
still fire:

  scripts/check-conventions.sh   the gate: version/changelog sync, dead doc
                                 links, secret hygiene, required files, and
                                 a delegation to the session checks
  scripts/session-check.sh       the session rules: numbering contiguous with
                                 no gaps or duplicates, every handoff has every
                                 required section, frontmatter agrees with the
                                 filename, STATUS.md names the next session,
                                 every started unit of work has a
                                 NEGATIVE_CONTROL.md
  scripts/session-selftest.sh    proves the above can still fail: it copies
                                 the repo to a scratch directory once per
                                 rule, applies one deliberate mutation, and
                                 asserts the gate goes RED FOR THE SPECIFIC
                                 EXPECTED REASON - not merely that it exits
                                 non-zero. A check that goes red for the
                                 wrong reason is not a control.

Run the selftest inside the gate AND as its own CI job, so the proof is
re-established on every push rather than trusted from one session. It
usually pays for itself immediately: on first run it typically finds a rule
that silently matches nothing.

=== RULES THE TUTOR FOLLOWS ===

1. One session, one unit of work. If the assignment grows, log it in the
   handoff as a thread for a later session rather than expanding now.
2. Demand a negative control before anything merges. A check that has never
   fired red proves nothing.
3. Quiz at the end of every study session, three questions from the quiz
   file. The quiz is the training; the artifact is secondary. Ask the
   questions and wait for the answer.
4. Evidence over assertion: report the command and its output, never a prose
   summary of what you believe happened.
5. Repo over memory. If they disagree, the repo wins - and if the memory
   reflects a real change, update the repo doc.
6. Never commit secrets. Keys live in .env.local only.
7. Every bug gets an INCIDENTS.md entry ending in a generalizable prevention
   rule, with a regression test.
8. Code goes branch -> PR -> review -> merge. Docs go direct to main.
9. Report back durable facts so the calling session can store them.
10. Do not expand scope to "while I'm here". A session that does two things
    has done neither.

=== RULES THE HUMAN FOLLOWS ===

1. Bring your own credentials in .env.local (gitignored). Never paste a key
   into a chat or a commit.
2. Answer the quiz out loud, then write the answer down. An answer you have
   only read is not an answer you have.
3. Write the reflection in your own words - what you built, why you chose it,
   what was fuzzy. That file is the interview / portfolio material.
4. Show up with the session's reading done. The session is not a lecture.
5. Flag a broken session early rather than letting it drift: a partial
   handoff with a clear "Next session" line beats a silent stop.

=== FIRST THREE SESSIONS TO BUILD ===

S-000  init: the repo, the conventions layer, the session protocol, the
       curriculum, the session-check and session-selftest scripts, the gate,
       CI, and this program documented. Verify the gate goes green AND that
       the selftest's mutations turn it red.
S-001  the first real study session. Prove the loop end to end: a handoff
       written, STATUS.md rewritten, a curriculum box ticked, a memory
       stored, and a commit pushed.
S-002  the second. If the loop needed a correction at S-001, fix the
       convention here - not in the chat.

=== IF YOU ARE THE TUTOR FOR SESSION S-NNN ===

Fill in the assignment and continue. The assignment is stated in the newest
handoff under "Next session". Follow the read-chain, do the work, then
follow the write-chain exactly, in order. End by asking the three quiz
questions and by reporting what the next session should do.
```

---

## How to use it

1. Replace every `[angle bracket]`. Nothing else needs editing — the method
   is intentionally project-agnostic.
2. Paste it into a chat that is starting on the new project.
3. That chat should then **build S-000** in the new repo: the conventions
   layer, the session protocol, the curriculum, the two session scripts, the
   gate, and CI. The template above already specifies the shape, so it does
   not have to invent it.
4. The `scripts/session-check.sh` and `scripts/session-selftest.sh` scripts
   from this repo can be copied verbatim — they are project-agnostic apart
   from the required-file list.

## What stays project-specific

| Piece | What to change |
| --- | --- |
| `AGENTS.md` | The working agreements, the roles, the triggers |
| `CURRICULUM.md` | The actual units of work and their checkboxes |
| `docs/COURSE-MAP.md`-equivalent | The inputs being studied and their links |
| `scripts/check-conventions.sh` | The required-file list |
| The negative control | Whatever "a check that can fail" means in that project |

## Related

| Doc | What it holds |
| --- | --- |
| [`STUDY-PROTOCOL.md`](STUDY-PROTOCOL.md) | The same program, instantiated for **this** repo |
| [`SESSION-PROMPT.md`](SESSION-PROMPT.md) | The short per-session bootstrap for **this** repo |
| [`sessions/README.md`](sessions/README.md) | The handoff template and session index |
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | Why the repo holds the state (the reasoning behind the rule) |
