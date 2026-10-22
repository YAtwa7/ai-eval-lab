# C1 - Building Reliable Agents with LangSmith: quiz bank

Three questions per session, asked at the end of the session by the tutor.
The point is not trivia - it is whether you can **explain the thing without
looking at the notes**. Answer out loud, then write the answer here.

A question with a "why" is worth more than one with a right answer.

## Format

```
### Q<n>. <question>

**My answer:**
<in your own words - not a paste from the course>

**Where I got it wrong / what was fuzzy:**
<honest - this is the part that makes the next session better>
```

## Questions

### S-001

1. What is the difference between evaluating a deterministic function and
   evaluating an LLM agent, and what does that difference force you to build?
2. What does a trace give you that a log file does not?
3. When a trace fails in production, what is the correct next step, and what
   must NOT happen to the golden dataset?

### S-002

1. When do you use a code-based evaluator instead of a judge, and why is the
   default answer "code-based"?
2. What is the difference between pointwise and pairwise evaluation, and
   when is pairwise the better choice?
3. What does an experiment in this context buy you that a single eval run
   does not?

### S-003

1. What is the difference between an offline eval and an online eval, and
   what does each catch?
2. Why does a prompt change constitute a regression risk?
3. What does "automation" mean in the context of an eval pipeline, and what
   is it automating?

### S-004

1. What are the components of an agent, and which ones can you evaluate
   independently?
2. Why is "the answer was correct" a weaker signal than "the router chose
   the right skill"?
3. What is the difference between a skill evaluation and a trajectory
   evaluation?

### S-005

1. What does a router evaluation measure that a trajectory evaluation does
   not?
2. Why do you build a dataset from traces rather than writing cases by hand?
3. When is a human label genuinely required?

### S-006

1. What is a trajectory evaluation, and what does it catch that an
   answer-level check cannot?
2. What is a convergence score and what failure does it detect?
3. Why does an experiment need a baseline to be meaningful?

### S-007

1. What makes a judge rubric ambiguous, and how would you find out?
2. What is the difference between a threshold and a baseline?
3. What is one way an LLM judge is systematically biased, and how do you
   test for it?

### S-008

1. What is the difference between a dataset and an experiment?
2. Why would you re-run the same eval on a new prompt version?
3. What information does a trace carry that an eval result does not?

### S-009

1. Why do you need human feedback in the loop at all, if you have a judge?
2. What is an annotation queue for, in concrete terms?
3. What does "online evaluation" cost that "offline evaluation" does not?

### S-010

1. What does Cohen's kappa measure that a raw agreement rate does not?
2. Why is the calibration set balanced, and what happens if it is not?
3. If your judge disagrees with humans in a structured way, what does that
   tell you, and what do you do about it?

### S-011

1. Why can a token-overlap metric score Arabic badly?
2. What is the difference between an Arabic *eval* problem and an RTL
   *rendering* problem?
3. If your corpus has no Arabic content, what does your Arabic RAG score
   actually measure?

### S-012

1. What is the difference between a prompt-injection finding and a
   hallucination finding?
2. Why must an adversarial suite fail closed rather than retry?
3. What is the five-answer shape of a good interview response about eval
   quality?
