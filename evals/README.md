# evals/ — the harness

Everything reusable about measuring quality lives here. The labs use it; the
labs do not own it.

| Path | Holds |
| --- | --- |
| `harness/` | The runner: provider interface, case loading, scoring loop, report writer, baseline diffing |
| `datasets/golden/` | Versioned golden cases. The contract that defines "good" |
| `judges/` | Judge rubrics, versioned. A rubric change invalidates calibration |
| `metrics/` | Thin wrappers over Ragas / DeepEval / custom metrics, behind one interface |
| `configs/` | Per-lab eval configs: which cases, which metrics, which thresholds |
| `reports/` | Generated output. Gitignored - model output can embed source content |

## The provider interface

`harness/providers.py` exposes one interface with swappable backends:

| Backend | Use | Key |
| --- | --- | --- |
| Gemini | default generator and judge | `GEMINI_API_KEY` |
| Groq | fallback | `GROQ_API_KEY` |
| OpenRouter | fallback | `OPENROUTER_API_KEY` |
| Ollama | offline | none |

Two reasons it is an interface and not a direct SDK call, both learned the
hard way:

1. **The judge should not be the generator.** Self-preference bias inflates
   scores when a model judges its own output. Being able to point the judge
   at a different provider is the cheapest defense.
2. **Free tiers differ and change.** Pinning one provider makes the harness
   brittle; the interface makes a swap a config change.

## Reports

Reports land in `evals/reports/` (gitignored). Model output can embed source
content, so a report is repo surface even when it is not committed.

## Status

Not implemented. `harness/`, `metrics/`, and `configs/` are placeholders.
