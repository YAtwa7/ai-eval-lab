# configs/ — per-lab eval configuration

Each config names the cases, the metrics, and the thresholds for one lab.

```yaml
lab: labs/02-golden-dataset
dataset: evals/datasets/golden/0.1.0
metrics:
  - name: faithfulness
    kind: ragas
    threshold: 0.85
    tolerance: 0.03     # regression tolerance vs the stored baseline
  - name: context_precision
    kind: ragas
    threshold: 0.80
    tolerance: 0.03
```

`threshold` is derived from data, not taste. `tolerance` is how far a score
may drift from the baseline before the gate fires - see
`docs/EVAL-STRATEGY.md`.

## Status

Empty. The first config lands with its lab.
