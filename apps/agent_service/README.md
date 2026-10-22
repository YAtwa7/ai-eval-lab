# Agent service (LangGraph)

**Purpose:** A tool-using agent with a router and named skills, so trajectory, tool-selection, argument-correctness and convergence scoring have a subject that actually routes and takes a variable number of steps.
**Built in:** S-004
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
