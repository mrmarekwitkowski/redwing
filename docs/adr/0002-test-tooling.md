# ADR-0002: Test Tooling

## Status

Accepted

## Context

As redwing's codebase grew, a test framework and coverage tool needed to be established. The choice had to fit a gem
project with no non-technical stakeholders and a white-box testing context.

## Decision

Use **RSpec** as the test framework and **SimpleCov** for coverage measurement.

- `spec/` mirrors `lib/` structure
- SimpleCov configured via `.simplecov` (not inline in `spec_helper.rb`)
- Coverage reports written to `tmp/` (already gitignored)
- Branch coverage enabled; minimum threshold deferred until real specs cover the codebase

## Consequences

### Positive

- RSpec is the gem ecosystem standard — familiar, well-documented, good tooling
- SimpleCov's `.simplecov` extraction keeps `spec_helper.rb` clean
- `tmp/` consolidates all generated output without extra `.gitignore` entries

### Negative

- RSpec's DSL is more verbose than Minitest for trivial assertions
- Coverage threshold not yet enforced — technical debt to address once spec suite matures

## Alternatives Considered

1. **Minitest**: leaner, ships with Ruby stdlib — rejected in favour of RSpec's expressiveness and ecosystem fit
2. **Cucumber**: rejected — no non-technical stakeholders, white-box context, not conventional for gem projects
