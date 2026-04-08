# ADR-0006: Configuration and Logging

## Status

Accepted

## Context

Redwing needs a central place to manage runtime configuration (e.g. views root, log file path) and an environment-aware
logging strategy. Both should be configurable by the user without requiring changes to the framework.

## Decision

### Configuration

Introduce `Redwing::Config` — a plain Ruby object with `attr_accessor` attributes and sensible defaults:

- `views_root`: `'app/views'`
- `log_file`: `'log/redwing.log'`
- `logger`: lazily initialized via `Redwing::Logger.create`

Expose configuration via:

```ruby
Redwing.configure do |config|
  config.views_root = 'custom/views'
  config.logger = Logger.new($stdout)
end
```

`Redwing.config` returns the singleton config instance.

### Logging

Introduce `Redwing::Logger` — a factory that creates an appropriate `::Logger` based on the environment:

- **Development** (default): plain text to `$stdout`
- **Production** (`RACK_ENV=production`): JSON to `config.log_file`; also writes to `$stdout` if `DEBUG` env var is set

JSON format includes `timestamp`, `severity`, and `message` fields.

`MultiIO` handles writing to multiple targets simultaneously in production.

### Rationale

- Block-based `configure` DSL groups all config in one place — familiar to Rails developers
- Lazy logger initialization avoids requiring `Redwing::Logger` at load time
- Environment-aware defaults follow the Hanami/Rails convention of plain text in development, structured logs in
  production
- `log_file` in `Config` (not hardcoded in `Logger`) keeps the factory free of assumptions

## Consequences

### Positive

- Zero-config defaults — existing apps need no changes
- Logger and views root are both overridable per app
- Production JSON logging is ready for log aggregation tools

### Negative

- `MultiIO` is a custom implementation — not battle-tested at scale
- No log levels exposed via config yet

## Alternatives Considered

1. **Hardcoded `$stdout` logger**: Simple but not suitable for production use
2. **Config file (`redwing.yml`)**: Previously used for `type:` — removed in favour of convention-based inference and a
   Ruby DSL for config
3. **`dry-configurable`**: More powerful but adds a dependency; plain Ruby is sufficient for now
