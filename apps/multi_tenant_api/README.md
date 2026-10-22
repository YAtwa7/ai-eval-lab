# Multi-tenant API

**Purpose:** A tenant-isolated API with role-based access control - the target for tenant-leak and isolation probes, and the thing that makes 'multi-tenant isolation' and 'RBAC' testable rather than aspirational.
**Built in:** S-011
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
