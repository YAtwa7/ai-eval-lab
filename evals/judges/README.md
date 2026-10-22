# judges/ — LLM-as-judge rubrics

A judge is only as good as its rubric. Each rubric here is a **scoring
contract**: criteria, edge cases, and the version it was calibrated at.

## Shape

```markdown
## Criterion: faithfulness
PASS when ...
FAIL when ...

Edge case: if the context genuinely does not contain the answer, a
"the documents do not cover this" answer is a PASS. Refusing correctly
is faithful behaviour, not a miss.
```

That edge-case clause is the whole game. A rubric without stated edge cases
gets guessed at, inconsistently, by the judge - and you find out only when
the score is wrong.

## Versioning

A rubric change invalidates the calibration. The rubric version and the
calibration run it was measured against are recorded together. See
`docs/JUDGE-CALIBRATION.md`.

## Status

Empty. The first rubric lands in S-002.
