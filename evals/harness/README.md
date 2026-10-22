# harness/ — the runner

The reusable machinery: load cases, call the system under test, score with
the configured metrics, write a report, diff against a stored baseline.

| Module | Responsibility |
| --- | --- |
| `providers.py` | One interface, swappable backends (Gemini / Groq / OpenRouter / Ollama) |
| `cases.py` | Load and validate a versioned golden dataset |
| `runner.py` | Execute cases, apply metrics, collect scores |
| `baselines.py` | Store and diff score baselines; decide pass/fail |
| `report.py` | Write the scorecard to `evals/reports/` |

## The baseline is stored, not recomputed

Recomputing the baseline in the same run makes every comparison green,
which makes it not a gate. The baseline is an artifact, versioned alongside
the dataset it was produced from.

## Status

Empty. The harness lands in S-002.
