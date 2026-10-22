# golden/ — versioned golden cases

A golden dataset is the contract that says what "good" means. It changes
when the product changes, and it changes **deliberately**.

## Rules

- **Version it.** Every case carries the dataset version. A score without a
  dataset version is not comparable.
- **Never regenerate in place.** New dataset, new version, explicit
  re-baseline. A silently replaced dataset makes every comparison noise.
- **Seed from real failures.** Production traces, bug reports, support
  tickets. Not imagined cases.
- **Promote traces into cases.** A trace that failed in production becomes
  a permanent case.
- **Include the hard cases.** The cases where the judge and a human disagree
  are the most valuable in the set.

## Shape

```yaml
dataset_version: "0.1.0"
cases:
  - id: rag-en-001
    language: en
    input: "What is the annual leave entitlement for a new joiner?"
    context: ["..."]          # what retrieval returned
    expected:
      answer_contains: ["30 working days"]
      answer_must_not_contain: ["60 days"]
    tags: [rag, policy, golden]
    source: "trace-2026-10-14-9f3a"   # where it came from
```

## Status

Empty. The first dataset lands in S-002.
