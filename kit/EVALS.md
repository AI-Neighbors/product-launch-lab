# Coach eval contract

The kit currently has no model runtime. Its evals are therefore deterministic
contract cases, not a benchmark of model quality.

`kit/evals/coach-cases.json` uses synthetic scenarios to keep PR rescue behavior
stable: identify the current phase, cite evidence, choose one decision, and give
one next action without inventing proof or performing external actions.

## Upgrade path

- Add promptfoo only when a real Coach prompt/provider runner exists. Reuse these
  cases as the dataset and add assertions for the required fields and safety
  constraints. Keep providers, keys and participant data out of CI by default.
- Add Phoenix only when Coach runs as a bot/service that emits OpenTelemetry or
  OpenInference spans. Trace redacted stage decisions and latency, not raw
  Telegram messages, forms or product data.

Until then, the existing shell CI and this fixture contract are the source of
truth; no external telemetry dependency is required.
