# metrics/ — metric wrappers

Thin wrappers over Ragas, DeepEval, and custom metrics, behind one
interface so a lab does not care which library produced a number.

## Why wrap rather than call directly

- **One report format.** Every metric reports the same way, so a scorecard
  compares cleanly across labs.
- **One place to fix a library upgrade.** When Ragas renames a metric, one
  wrapper changes instead of every lab.
- **Variance tracking.** The wrapper records each metric's run-to-run spread,
  because a threshold inside the noise band is not a threshold.

## Status

Empty. The first wrappers land in S-002.
