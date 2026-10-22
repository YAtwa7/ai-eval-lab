# JUDGE CALIBRATION — how to trust an LLM-as-a-judge

An LLM-as-a-judge is a claim about quality that nobody checked. It is also
the mechanism most of an eval suite depends on. So it needs evidence, the
same way a test needs a negative control.

The question is not "is the judge good?" — it is:

> **On what fraction of cases does the judge agree with a human, and at what
> threshold does that agreement peak?**

## The method

### 1. Build a labelled calibration set

- **Size:** 100 cases is the practical minimum for a usable agreement
  estimate. Below ~50 the confidence interval is too wide to say anything
  useful. Above ~200 the marginal cost usually exceeds the marginal value.
- **Source:** sample from the *golden dataset*, not from easy examples. If
  the judge only ever sees cases where the answer is obviously right, you
  will measure agreement you do not have.
- **Labels:** two humans label each case independently, then reconcile
  disagreements by discussion. The disagreements are the interesting part —
  they tell you where your rubric is ambiguous.
- **Balance:** include roughly equal positives and negatives. An all-passing
  set measures nothing, and an all-failing set measures nothing.

### 2. Define what "agreement" means

Pick one and write it down:

| Measure | What it tells you | When to use |
| --- | --- | --- |
| **Exact agreement rate** | Fraction where judge score == human label | Binary pass/fail judgements. Simple, easy to explain. |
| **Cohen's kappa** | Agreement corrected for chance | The default for categorical labels. Chance correction matters when the majority class dominates. |
| **Pearson / Spearman** | Rank correlation of scores | Continuous judge scores against human scores. Use Spearman if the scale is ordinal. |
| **Within-one-band** | Judge within 1 point of human on a 1-5 scale | Ordinal rubrics where exact agreement is unreasonably strict. |

**Do not report bare agreement rate alone.** With an imbalanced set, a judge
that always says PASS scores 80% agreement on a set that is 80% PASS, and
has learned nothing. Report kappa (or a balanced accuracy) alongside it.

### 3. Sweep the threshold

The judge's *raw* score is not the answer; the threshold turns it into a
decision. Sweep it:

```
threshold   judge_pass   agreement   kappa   false_pos   false_neg
0.30        ...           ...         ...     ...         ...
0.40        ...
0.50        ...
0.60        ...
```

Pick the threshold that maximises agreement (or kappa), not the one that
gives the nicest pass rate. Then report:

- the chosen threshold,
- agreement and kappa at that threshold,
- the **margin**: how much score separates correct judgements from
  incorrect ones,
- the false-positive and false-negative rates, because they have different
  costs. A false negative on a *safety* case is much worse than a false
  positive.

### 4. Report the failure modes, not just the number

A judge that disagrees with humans in a *random* pattern is one thing. A
judge that disagrees in a *structured* pattern is a different thing, and far
more useful. Look for:

| Pattern | What it means |
| --- | --- |
| Disagrees on long answers | Length bias — the judge rewards verbosity |
| Disagrees on the first position | Position bias — swap the order and re-measure |
| Disagrees on its own family | Self-preference — the judge favours its own model's output |
| Disagrees on Arabic | Language bias — the rubric does not transfer |
| Disagrees on borderline cases | Threshold problem, or genuinely ambiguous rubric |

Structured disagreement is a bug you can fix. Random disagreement means the
judge is not reliable at this task and the metric should not be used as a
gate.

### 5. Control the obvious biases

- **Position bias:** present each pair in both orders and score only where
  the verdict is stable, or average the two.
- **Verbosity bias:** add an explicit clause — "a longer answer is not a
  better answer; do not reward detail the criterion did not ask for."
- **Self-preference:** point the judge at a different provider than the
  generator. `evals/harness/providers.py` makes this a config change.
- **Rubric drift:** version the rubric. A changed rubric invalidates the
  calibration and must trigger a re-run.

### 6. Keep the calibration set alive

- Re-run it whenever the judge model, the rubric, or the dataset changes.
- Keep the labelled cases in the repo (as data, versioned) so the comparison
  is reproducible.
- Track agreement over time as a scorecard. A judge that was 0.88 agreeing
  last month and 0.71 now is a story you need to be able to tell.

## What to write down

`docs/JUDGE-CALIBRATION.md` in this repo is the living record. The
calibration lab (`labs/06-judge-calibration/`) produces:

| Artifact | Content |
| --- | --- |
| `golden/calibration-set.yaml` | The 100 labelled cases, with both human labels and judge scores |
| `judges/rubric.md` | The rubric under test, versioned |
| `results/agreement.csv` | Per-case: case id, human label, judge score, agree/disagree |
| `results/threshold-sweep.csv` | The sweep table |
| `NEGATIVE_CONTROL.md` | Proof the agreement check can fail |
| `REFLECTION.md` | What the failure modes turned out to be, in your words |

## The interview answer

This is the sentence this whole lab exists to make possible:

> "I calibrated the judge against 100 human-labelled cases. Agreement was
> 0.87 with a kappa of 0.74 at a threshold of 0.55 — that threshold came
> from the sweep, not from a guess. The disagreements were structured, not
> random: the judge was systematically more lenient on longer answers, so I
> added an explicit verbosity clause to the rubric and re-ran. The margin
> between correct and incorrect judgements was 0.22, which is narrow, so I
> gated on code-based checks where I could and used the judge only where
> the criterion was genuinely semantic."

That answer contains: a method, a number, a failure mode, a fix, an honest
limitation, and a judgement about when *not* to trust your own metric. It is
the answer that separates a lead from a candidate who has read a tutorial.

## Related

- [`EVAL-STRATEGY.md`](EVAL-STRATEGY.md) — when to use a judge at all, and
  threshold selection in general.
- [`PROVER.md`](PROVER.md) — what a reviewer will demand about a judge.
