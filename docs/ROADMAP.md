# ROADMAP — ai-eval-lab (done / next / later / won't)

> Sessions own this file. Releases are recorded in [CHANGELOG.md](../CHANGELOG.md),
> not here — this file says *what* and *why*; the changelog says *when*.
>
> Docs go direct to `main`; code goes branch -> PR -> QA-PROVER -> merge
> (see [PROVER.md](PROVER.md) and [AGENTS.md](../AGENTS.md)).

## Now (0.1.x — scaffolding, live)

- [x] **v0.1.0** — repo scaffold: conventions layer, versioning, the gate,
  CI, and the licence
- [x] **v0.1.0** — the session protocol: one session = one chat = one
  handoff, with session integrity mechanically enforced
      ([protocol](SESSION-PROMPT.md), [template](sessions/README.md),
      [checks](../scripts/session-check.sh))
- [x] **v0.1.0** — the course map: three courses, verified links, durations,
  certificate mechanics, and the LCAE credential on top
      ([COURSE-MAP.md](COURSE-MAP.md))
- [x] **v0.1.0** — the twelve-session roster mapped to the target role's
      clauses, nine lab briefs, three app briefs, and the eval harness layout
- [x] **v0.1.0** — eval strategy, judge calibration method, and reviewer
      criteria written before the first eval exists

## Next — the core program (sessions S-001 .. S-007)

- [ ] **S-001** — C1 Module 0-1: observability and tracing
      → `apps/agent_service/` skeleton, `labs/01-tracing/`
- [ ] **S-002** — C1 Module 2: datasets, experiments, code-based / judge /
      pairwise evaluation → `labs/02-golden-dataset/`, `labs/03-judge/`
- [ ] **S-003** — C1 Module 3: online evals and automations
      → `labs/08-ci-gate/` (draft)
- [ ] **S-004** — C2 Lab 1: building the agent → `apps/agent_service/`
- [ ] **S-005** — C2 Labs 2-3: tracing, router and skill evaluations
      → `labs/01-tracing/`, `labs/04-component-evals/`
- [ ] **S-006** — C2 Labs 4-5: trajectory evaluations, convergence score,
      structured experiments → `labs/05-trajectory-evals/`
- [ ] **S-007** — C2: improving the judge, monitoring agents, graded
      assignment → **C2 certificate claimed**

## Later — the differentiating labs (S-008 .. S-012)

- [ ] **S-008** — C3 Modules 1-2 (fast pass; C1 covered the core)
- [ ] **S-009** — C3 Modules 3-5: prompt hub, human feedback and annotation
      queues, production observability → `labs/09-monitoring/`
- [ ] **S-010** — judge calibration: 100 human labels, agreement, threshold
      from data → `labs/06-judge-calibration/` *(the differentiator)*
- [ ] **S-011** — bilingual EN/AR and RTL → `labs/07-bilingual-rtl/`
      *(the differentiator)*
- [ ] **S-012** — red team, final CI gate, and the five rehearsed interview
      answers → `labs/08-ci-gate/`

## Won't (explicitly out of scope)

- **A production service.** This is a lab. The apps exist to be measured.
- **A hosted platform.** No multi-tenancy, no billing, no user accounts.
- **A TypeScript mirror of the target stack.** The eval frameworks are
  Python-native and the study budget is finite; the stack knowledge comes
  from reading the target's code, not from rebuilding it here.
- **Paying for the LCAE exam before a role is live.** The free practice exam
  measures readiness; the paid exam measures willingness to spend $99.
- **Claiming a certificate before it is issued.** See
  [CERTIFICATES.md](CERTIFICATES.md).
