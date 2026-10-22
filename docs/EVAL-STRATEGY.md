# EVAL STRATEGY — how to build an eval that means something

The question this doc answers: *you have a golden dataset and an LLM. What
now?* Most eval work fails not from bad tooling but from an unanswered
question — **what am I actually measuring, and what would make this check
red?**

## 1. Start from the failure, not the metric

Never start with "let me add faithfulness." Start with a failure you can
describe concretely:

> "When a user asks a policy question the RAG service answers from a document
> that was not retrieved, and states a confident, wrong entitlement."

Now the metric follows: that is a **grounding** failure, so you need a
faithfulness check (is every claim in the answer supported by the retrieved
context?) *and* a context-precision check (was the right document retrieved
at all?). Those two fail for different reasons and have different fixes —
a retrieval bug versus a generation bug. One metric cannot tell them apart.

Write the failure down. The lab brief starts there, not with a library name.

## 2. Pick the evaluator class deliberately

Three classes. Choosing wrongly is the most common mistake in eval work.

| Class | Use when | Cost | Determinism | Example |
| --- | --- | --- | --- | --- |
| **Code-based** | The answer has a checkable form | near-zero | total | output matches a regex, JSON parses, the tool called was `search_orders`, the answer cites doc id 42 |
| **LLM-as-a-judge** | Quality is semantic and a rubric can be written | per-call, variable | none | "is this answer fully supported by the context?" |
| **Human** | Ambiguity is irreducible, or you need a ground truth | highest | n/a | ground-labelling the calibration set |

The rule of thumb: **use the cheapest class that can detect the failure.** A
judge on a question with a right answer is a budget error and a flake
source. A regex on "did the agent call the right tool" is not a
limitation, it is a feature.

Judge use is justified when the criterion is genuinely semantic — tone,
completeness, whether the answer is *relevant* rather than merely
*correct*. Even then, most of your suite should be code-based. A suite that
is 100% judge is slow, non-deterministic, and cannot fail reliably.

## 3. Golden datasets are versioned artifacts

A golden dataset is not a fixture. It is the contract that says what "good"
means, and it changes when the product changes.

Rules:

- **Version it.** Every case carries the dataset version it belongs to. A
  score is meaningless without knowing which dataset produced it.
- **Never regenerate in place.** A regenerated dataset silently changes the
  baseline and every comparison against it becomes noise. New dataset, new
  version, explicit re-baseline.
- **Seed from real failures.** A dataset built from imagined cases tests
  imagined failures. Seed it from production traces, bug reports, and
  support tickets.
- **Promote traces into cases.** When a trace fails in production, that
  failure becomes a test case. This is the loop that makes the suite grow
  in the right direction.
- **Include the hard cases.** The cases that make the judge disagree with a
  human are the most valuable ones in the set.

## 4. Thresholds come from data, not from taste

A threshold chosen by feel is a number nobody can defend and everybody
argues about. A threshold chosen from data is a fact.

Two ways to set one:

**From the label distribution.** If you have human labels, compute the
metric's score distribution on positives and negatives. The threshold is
where the two distributions separate — and the *separation* is what you
report, because that is the number that tells you whether the metric works
at all.

**From the calibration set.** Judge against a human-labelled set, measure
agreement, and pick the judge threshold that maximises agreement with the
human labels. See [`JUDGE-CALIBRATION.md`](JUDGE-CALIBRATION.md).

**Report the margin.** A metric that scores 0.62 on positives and 0.58 on
negatives is useless as a gate even if 0.60 is the "right" threshold. Say
what the margin is.

## 5. Non-determinism needs a variance budget

The same input, run three times, gives three scores. That is not a bug to
paper over — it is a property to measure.

- **Run every eval at least three times** while you are establishing a
  threshold.
- **Report the spread**, not just the mean. A metric with a mean of 0.80 and
  a spread of 0.15 has a threshold that is mostly noise.
- **A flaky check is a finding, not a retry.** If a gate fails 1 in 10 runs
  because the judge wobbled, that gate is unfit to gate. Fix the gate
  (tighter rubric, deterministic judge, code-based check) or remove it.
  Never add a retry to make it green — that hides the instability that the
  gate existed to surface.

## 6. Regression gates compare against a baseline

The CI gate is a **diff**, not an absolute. Score today versus score at the
last known-good commit:

```
PASS  if every metric is within its tolerance of the baseline
FAIL  if any metric drops beyond its tolerance
```

Two decisions here:

- **Per-metric tolerance**, not one global number. A judge metric with a
  wide natural spread gets a wide tolerance; a deterministic check gets
  zero tolerance.
- **The baseline is stored, not recomputed.** Recomputing the baseline in
  the same run means the comparison is always green, which means it is not a
  gate.

The gate's own negative control matters as much as the eval's: prove that
changing a prompt or a model version actually turns it red. A gate that has
never fired has never been tested.

## 7. Bilingual and RTL evaluation is not translation

An Arabic golden set is not the English one with the strings swapped. Three
things break:

1. **The corpus.** Retrieval quality in Arabic depends on the corpus
   actually containing Arabic answers to the questions you ask. An English
   corpus indexed with an Arabic query retrieves nothing, and every
   downstream metric collapses to a constant.
2. **The metric.** Some metrics are semantic and cross-lingual; some are
   token-overlap based (ROUGE, BLEU) and score Arabic badly because
   Arabic morphology inflates the token count. Know which kind you are using
   before you trust its number.
3. **The judge.** A judge rubric written in English, applied to Arabic
   output, measures something you did not intend. Either write the rubric in
   the target language, or validate that the judge reasons correctly in that
   language before trusting its scores.

RTL adds a rendering dimension that is orthogonal to language: the answer can
be semantically perfect and still be unusable because the layout is wrong.
That is a rendering check, not an eval.

## 8. The rubric is the unit of quality

A judge is only as good as its rubric. Write it as a scoring contract:

```markdown
## Criterion: faithfulness
PASS when every factual claim in the answer is entailed by the retrieved
context, and the answer contains no claim absent from it.
FAIL when the answer asserts something the context does not support, or
when it declines to answer despite relevant context.

Edge case: if the context genuinely does not contain the answer, a
"the documents do not cover this" answer is a PASS. Refusing correctly
is faithful behaviour, not a miss.
```

That edge case is the whole game. A rubric without stated edge cases gets
guessed at, inconsistently, by the judge — and you will discover that only
when the score is wrong.

## 9. A checklist before any eval merges

- [ ] The failure it detects is written down in the lab brief.
- [ ] The evaluator class is the cheapest one that can detect it.
- [ ] The golden cases are versioned and came from real failures.
- [ ] A threshold is set from data, and the margin is reported.
- [ ] The metric's run-to-run spread is measured (3+ runs).
- [ ] `NEGATIVE_CONTROL.md` records the command, the mutation, and the red output.
- [ ] The rubric states its edge cases.
- [ ] The judge model is not the generator model, where it matters.
- [ ] The cost of running it is known and acceptable.

## 10. The questions a hiring panel will ask

If you can answer these about your own evals, you can defend them.

1. How do you know your judge is right?
2. What is your metric's run-to-run variance, and how does it affect your
   threshold?
3. Show me an eval that fired red and what it caught.
4. How do you decide between a code-based check and a judge?
5. What happens when a model version changes and your scores drift — is that
   a regression or a new baseline?
6. How do you know your golden dataset still represents real traffic?
7. What is the cost of the suite per run, and how many times a day does it
   run?
8. Which of your evals is the weakest, and what would you do to fix it?
