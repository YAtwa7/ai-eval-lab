# Lab 08 - CI eval gate

**JD clause:** "build and maintain evaluation pipelines that continuously measure agent quality and catch regressions when models, prompts, or workflows change"
**Sessions:** S-003, S-012
**Status:** not started

## The failure this lab detects

Someone changes a prompt or bumps a model version, quality silently degrades, and it is discovered by a customer. The fix is a CI gate that diffs scores against a stored baseline and fails the build on a drop beyond tolerance.

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
