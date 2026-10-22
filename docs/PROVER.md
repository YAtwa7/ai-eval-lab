# PROVER — the reviewer brief

What a QA-PROVER must establish before a change merges here. The operational
wrapper is [`agents/qa-prover.md`](../agents/qa-prover.md); this file is the
criteria.

The reviewer is **review-only**: no edits, no fixes, no merges. A reviewer
who fixes things has stopped being independent.

## Verdict format

```
PASS | PASS-WITH-FINDINGS | FAIL
```

Then numbered findings, each labelled `blocker` / `major` / `minor` / `nit`,
each with **file:line evidence** and **the command that produced it**.
Findings without evidence are discarded.

| Verdict | Meaning |
| --- | --- |
| `PASS` | The reviewer ran the checks and can name the input that falsifies the new check. |
| `PASS-WITH-FINDINGS` | Blockers and majors are fixed and re-reviewed; minors may be deferred with a recorded reason. |
| `FAIL` | No merge. The finding is reproduced by the builder before anything else — a disputed finding is resolved with an artifact, not an opinion. |

## Mandate

1. **Replay the requirement yourself** before reading the diff's description.
   The claim in the diff is not the requirement; the requirement is upstream.
2. **Run the checks and report the exact commands and output:**
   `scripts/check-conventions.sh`, then `scripts/session-check.sh`, then the
   eval suite (`pytest -q`), and the lab's own eval command.
3. **Demand a negative control.** With the fix reverted or the check
   disabled, the check must fail. If no such evidence exists, that is a
   finding — an eval that has never fired red proves nothing.
4. **Never accept a prose summary, a screenshot of a passing run, or a green
   CI badge as proof.** Artifacts and logs from the same commit only.

## Eval-specific criteria

These are the things that make an eval review different from a code review.

### The failure is named

A new eval must state, in the lab brief, the concrete failure it detects. An
eval with no named failure is a metric collection, not a check.

### The threshold is defensible

- A threshold set by feel is a finding.
- Ask: what is the margin between passing and failing cases? A metric that
  scores 0.62 on positives and 0.58 on negatives does not gate.
- Ask: what is the metric's run-to-run spread? A gate whose threshold sits
  inside its own noise band is not a gate.

### The evaluator class is justified

Code-based, LLM-as-a-judge, or human? A judge used where a deterministic
check would do is a finding (cost, flakiness, and no extra signal).

### The judge is not self-preferring

If the judge and the generator are the same model family, that is a finding
unless there is a recorded reason.

### The rubric states its edge cases

A rubric without stated edge cases is a rubric the judge will guess at. Look
for the "if the context does not contain the answer, declining is correct"
clause. Its absence is a finding.

### The dataset is versioned

Golden cases belong to a dataset version. A regenerated dataset that silently
replaces the previous one is a finding: every comparison against the old
baseline is now noise.

### The gate has been proven to bite

The CI eval gate must have a recorded negative control: change a prompt or
a model version and show the build goes red. A gate that has never fired is
untested.

## Session-convention criteria

Because the session protocol is load-bearing here, the reviewer checks it too.

| Check | Finding if violated |
| --- | --- |
| The session file exists for the session number | The work is not in the repo |
| All template sections are present | A cold reader cannot resume |
| `STATUS.md` names the next session | The next chat starts cold |
| The curriculum box is ticked | Progress is not observable |
| The handoff's "Next session" matches the curriculum's next row | Two sources of truth disagree |
| Memory writes are listed | A later session cannot tell a stored fact from a repo fact |

## What is never a finding

- Style preferences the linter does not enforce.
- A missing test for code that has no behaviour worth asserting.
- A judge threshold that is in the right *region* but not the exact value
  the reviewer would pick — ask for the data, do not mandate your number.
- Missing coverage of a failure mode that is explicitly out of scope in the
  lab brief.

## After the merge

1. A bug found during review gets an `INCIDENTS.md` entry with a prevention
   rule and a regression test that fails against the old code.
2. A durable convention goes into the repo doc that owns it — the repo is
   canonical.
3. Only then, anything genuinely personal or session-contextual goes to the
   `ai-eval-lab` memory scope.
