# ADR-0001: Core Dependencies

## Status

Accepted

## Context

Redwing is a lightweight Rack-based web framework inspired by Rails. At project inception, foundational dependencies had
to be chosen for server handling, CLI, and utilities.

## Decision

Adopt Rack, Thor, and ActiveSupport as core runtime dependencies from the start.

- **Rack**: standard Ruby web server interface — aligns with redwing's identity as a Rack-based framework
- **Thor**: CLI toolkit for `redwing server`, `redwing console` commands — mature, well-tested, used by Rails itself
- **ActiveSupport**: utility layer (autoloading, extensions) — avoids reinventing common helpers

## Consequences

### Positive

- Rack keeps the framework interoperable with any Rack-compatible server (Puma, Falcon, etc.)
- Thor provides a proven CLI DSL with minimal boilerplate
- ActiveSupport reduces custom utility code

### Negative

- ActiveSupport is a heavy dependency for a "lightweight" framework — pulls in significant weight even when only a
  fraction is used
- Tight coupling to Rails ecosystem from day one

## Alternatives Considered

1. **Dry-CLI over Thor**: more modular, but less familiar and smaller community
2. **No ActiveSupport**: leaner, but would require rolling custom autoloading and utility helpers
