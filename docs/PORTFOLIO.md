# PORTFOLIO — resume bullets and the evidence behind them

**Rule: no invented numbers.** Every bullet below has placeholders in
`[brackets]` until the lab that produces the number has actually run. A
resume bullet with a fabricated metric is a liability in an interview, not a
shortcut — a Lead-level interviewer will ask how you measured it.

Fill each bracket from the artifact that produced it, and record the source
next to it.

---

## Resume bullets (fill after the labs land)

### Project header

> **ai-eval-lab** — AI evaluation lab for a non-deterministic agentic
> platform (Python, FastAPI, LangGraph, Ragas, DeepEval, Promptfoo,
> LangSmith). *Public: github.com/YAtwa7/ai-eval-lab*

### Bullets

**1. Evaluation harness**

> Built an LLM evaluation harness that scores RAG and agent outputs with
> golden datasets, code-based metrics, and a rubric-driven LLM-as-judge,
> across [N] versioned golden cases covering [N] failure classes; the suite
> runs in CI in [N] minutes and costs $0 to run.

*Fill from:* `evals/datasets/golden/`, `evals/metrics/`, the CI run time.

**2. Judge calibration — the differentiator**

> Calibrated an LLM-as-a-judge against a [100]-case human-labelled
> calibration set, measuring [0.XX] agreement (Cohen's kappa [0.XX]) and
> deriving the pass threshold from the score sweep rather than by judgement;
> identified [N] structured failure modes in the judge (e.g. [verbosity
> bias / position bias]) and closed [N] with explicit rubric clauses.

*Fill from:* `labs/06-judge-calibration/results/`.

**3. Regression gate**

> Implemented a CI eval gate that diffs metric scores against a stored
> baseline with per-metric tolerances, so a prompt or model change that
> degrades quality fails the build; proved the gate bites with a recorded
> negative control on every metric.

*Fill from:* `labs/08-ci-gate/`, `.github/workflows/ci.yml`.

**4. Bilingual evaluation**

> Built an English/Arabic evaluation set and RTL rendering checks for a
> RAG service, including an Arabic-calibrated judge rubric, and measured
> that token-overlap metrics mis-score Arabic ([X] points lower agreement
> than semantic metrics) — the reason the suite uses semantic scoring for
> the Arabic lane.

*Fill from:* `labs/07-bilingual-rtl/`.

**5. Red teaming**

> Built an adversarial suite ([N] prompt-injection, jailbreak, and
> tenant-leakage cases) that fails closed rather than retrying, and mapped
> findings to OWASP LLM Top 10 categories; [N] findings were fixed with
> regression tests and prevention rules.

*Fill from:* `labs/` red-team work, `INCIDENTS.md`.

**6. Quality engineering practice**

> Worked to a documented quality convention: every eval ships a negative
> control proving it fires red for the right reason, every bug leaves a
> prevention rule with a regression test, and code merges only through
> independent review with an evidence-based verdict.

*Fill from:* `docs/PROVER.md`, `INCIDENTS.md`, `scripts/check-conventions.sh`.

---

## The five rehearsed answers

These are the sentences that decide a Lead-level interview. Write them in
your own words in `docs/interview/Q&A.md`. A rehearsed answer you own beats
an improvised one you half-remember.

**Q1. How do you evaluate a non-deterministic agent?**
> Golden dataset first, then component evals, then trajectory evals, then a
> regression gate. The golden dataset is the contract — versioned, seeded
> from real failures, promoted from production traces. Component evals
> (router choice, skill correctness, tool arguments) localise the failure;
> trajectory evals catch the path pathologies an answer-level check misses.
> The CI gate diffs every metric against a stored baseline with
> per-metric tolerances, so a prompt or model change fails the build
> instead of shipping silently.

**Q2. Code-based eval vs LLM-as-a-judge vs human — when do you use each?**
> The cheapest class that can detect the failure. Code-based when the
> answer has a checkable form — a regex, a JSON schema, "did it call the
> right tool with the right arguments". Judge when quality is genuinely
> semantic and a rubric can be written. Human for irreducible ambiguity and
> for ground truth. Most of my suite is code-based; a 100% judge suite is
> slow, non-deterministic, and cannot fail reliably.

**Q3. How do you know your judge is right?**
> I calibrated it against a 100-case human-labelled set. Agreement and
> Cohen's kappa at a sweep of thresholds, with the threshold chosen from
> the sweep rather than by judgement. The more useful half is the failure
> analysis: the disagreements were structured, not random. [Name the
> actual failure mode you found.] That was a rubric bug, and I fixed it and
> re-ran. I also keep the judge on a different provider than the generator,
> because self-preference inflates scores.

**Q4. How do you catch a regression when someone changes a prompt?**
> Traces and datasets are versioned separately from the code, so a prompt
> change does not silently redefine "good". The CI gate reruns the golden
> set and diffs each metric against the stored baseline with per-metric
> tolerances. Deterministic checks get zero tolerance; judge metrics get a
> tolerance set from the metric's measured run-to-run spread, because a
> threshold inside the noise band is not a threshold. If a score drops
> beyond tolerance, the build fails — and the first question is whether the
> prompt or the judge moved.

**Q5. How do you test for prompt injection and tenant leakage?**
> Adversarial suites with fail-closed semantics — a suspected injection is
> a finding, never a retry. Prompt injection cases assert that the agent
> refuses the instruction regardless of how it is phrased or encoded;
> tenant-leakage cases assert that a response contains no artefact
> belonging to another tenant. I map findings to OWASP LLM Top 10
> categories, and every fix ships with a regression case that fails against
> the old code. The important discipline is that the adversarial suite
> runs in CI on every change, not as a one-off audit.

---

## Talking about the tools

The target stack is Azure / Microsoft Agent Framework / AutoGen. Neither
LangSmith nor Arize Phoenix is that stack, and the answer to "wrong tools?"
is a strength:

> "I learned the method on LangSmith and Phoenix — code-based versus
> judge versus human annotation, golden datasets, trajectory scoring, and
> the calibration discipline. The method is tool-agnostic; I would map it
> onto Azure AI Foundry's evaluation service and their agent framework. What
> is not negotiable is the golden dataset and a calibrated judge threshold,
> and neither depends on the vendor."

Then add the thing that only you can say:

> "The part I had to build myself was the bilingual lane. The frameworks
> assume English. Arabic needed its own corpus, its own rubric, and a
> check on which metrics actually transfer."

---

## Numbers to have ready

| Number | Source |
| --- | --- |
| Size of the golden dataset | `evals/datasets/golden/` |
| Judge agreement + kappa | `labs/06-judge-calibration/results/` |
| Threshold and margin | same |
| Metric run-to-run spread | metric wrappers |
| Suite runtime and cost per run | CI run + provider dashboard |
| Number of failure classes covered | golden dataset tags |
| Number of adversarial cases | red-team suite |
| Number of INCIDENTS entries | `INCIDENTS.md` |
| Number of sessions, hours studied | `docs/sessions/` |

Have the *denominator* ready too. "0.87 agreement on 100 cases" is a claim;
"0.87 agreement with a 95% confidence interval of roughly +/-0.07 on 100
cases" is a claim a Lead-level interviewer respects.
