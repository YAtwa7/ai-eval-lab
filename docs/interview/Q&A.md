# Interview Q&A — the rehearsed answers

The five answers in [`../PORTFOLIO.md`](../PORTFOLIO.md) are the ones that
decide a Lead-level interview. This file is where **you** write them, in
your own words, and where you sharpen them after each session.

**How to use this file.**

1. After each session, rewrite the answers to the questions that session
   touched. Say them out loud first — an answer you have only read is not
   an answer you have.
2. Keep them short. A two-minute answer that lands beats a five-minute
   answer that wanders.
3. Mark any answer you are **not** yet honest about. That list is your
   study queue.
4. Never state a number you have not measured. "I calibrated against 100
   cases" is a fact about the method; "0.87 agreement" needs a result file.

---

## The five

### Q1. How do you evaluate a non-deterministic agent?

**My answer:**

> _write it here_

**Honest?**

- [ ] I can say this without reading the repo
- [ ] I can name the concrete artifact behind each claim
- [ ] I can answer the follow-up: "which part would you do first?"

### Q2. Code-based eval vs LLM-as-a-judge vs human — when do you use each?

**My answer:**

> _write it here_

**Honest?**

- [ ] I can say this without reading the repo
- [ ] I can name a concrete case from my own suite for each class

### Q3. How do you know your judge is right?

**My answer:**

> _write it here_

**Honest?**

- [ ] I can state the agreement number and the threshold honestly
- [ ] I can name the failure mode I actually found
- [ ] I can say what I would do if the agreement were poor

### Q4. How do you catch a regression when someone changes a prompt?

**My answer:**

> _write it here_

**Honest?**

- [ ] I can explain per-metric tolerance and why it is not one global number
- [ ] I can answer: "what if the judge changed instead of the prompt?"

### Q5. How do you test for prompt injection and tenant leakage?

**My answer:**

> _write it here_

**Honest?**

- [ ] I can explain fail-closed vs retry
- [ ] I can name one real finding and its regression test

---

## Follow-ups that come after the five

These are the questions a Lead-level interviewer asks next. Prepare them as
you go, not the night before.

### On the harness

- Where does the golden dataset come from, and how do you know it still
  represents real traffic?
- Your judge and your generator — are they the same model? What does that
  do to your scores?
- What is the run-to-run variance of each metric, and how does that
  constrain your thresholds?
- What does your suite cost per run, and how many times a day does it run?
- Which of your evals is the weakest, and what would you do to fix it?
- If you had to delete one metric from the suite tomorrow, which one, and
  what would break?

### On the systems

- You said the corpus is bilingual. What happens to your retrieval metrics
  when the query language does not match the corpus language?
- How do you test an agent that legitimately takes a different number of
  steps on different inputs?
- A tool call fails transiently. Is that a trajectory failure or an
  infrastructure failure, and how does your suite tell them apart?

### On the practice

- How do you decide what is "good enough" to ship?
- What happens when the quality bar and the release date conflict?
- How would you teach a new QA engineer to read an eval suite?
- Your golden dataset is versioned. Who is allowed to change the definition
  of good, and what process does that require?

---

## Log

| Date | Session | Question touched | What changed |
| --- | --- | --- | --- |
| - | - | - | - |
