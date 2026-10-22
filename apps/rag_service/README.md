# RAG service (FastAPI)

**Purpose:** A retrieval-augmented service with a bilingual EN/AR corpus and a tenant dimension, so RAG metrics (faithfulness, context precision, context recall, answer relevancy) have something real to score.
**Built in:** S-001
**Status:** placeholder - not implemented yet

## Why this app exists

An eval harness with nothing to evaluate is a vocabulary exercise. This app
gives the metrics a real subject: real inputs, real outputs, real failure
modes. It is small on purpose - the goal is a testable surface, not a
product.

## Planned surface

_Not yet implemented. This section is written when the first session lands
code here._

## Notes

- Kept deliberately small: a few hundred lines is the target.
- Every LLM call goes through `evals/harness/providers.py`, never a
  provider SDK directly.
- Keys come from `.env.local`; nothing here reads a secret from the repo.
