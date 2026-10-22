# Lab 09 - Production monitoring

**JD clause:** "deploy these evaluation techniques to monitor the agent's performance in production"
**Sessions:** S-009
**Status:** not started

## The failure this lab detects

Quality drifts in production in ways no offline dataset predicted, and nobody is watching because the dashboard shows request counts, not behaviour. The fix is online evaluation and trace-driven monitoring.

## What you will build

- `app/` - the subject under evaluation (small, on purpose)
- `golden/` - versioned cases: input, context, expected outcome
- `judges/` - rubric definitions, versioned
- `tests/` - the eval suite; it asserts **scores**, not vibes
- `NEGATIVE_CONTROL.md` - proof the check fires red, for the right reason
- `REFLECTION.md` - your words: what you built, why you chose it

## Acceptance criteria

1. The failure above is stated in your own words at the top of `REFLECTION.md`.
2. The eval suite passes on the good implementation.
3. `NEGATIVE_CONTROL.md` records: the command, the mutation applied, and the
   red output - with the reason it went red.
4. The metric's run-to-run spread is measured over 3+ runs and reported.
5. Any threshold used is derived from data, and the margin is reported.
6. If a judge is used, its rubric states its edge cases and the judge model
   is not the generator model.
7. The golden cases are versioned and traced to a real failure.

## Definition of done

The lab is done when the gate is green **and** the negative control has
fired. An eval that has never gone red does not count as working.

## Notes

_Not started. This brief is replaced with session notes as the work lands._
