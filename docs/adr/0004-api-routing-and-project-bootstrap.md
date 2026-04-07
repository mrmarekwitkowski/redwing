# ADR-0004: API Routing and Project Bootstrap

## Status

Accepted

## Context

Redwing needs a way to define HTTP routes and serve JSON responses for `api` project types. The framework must also establish conventions for how generated projects are structured and how the server discovers routes at boot time.

## Decision

### Routing DSL

Adopt a flat, Sinatra-like DSL scoped inside a `Redwing.routes` block. Route handlers return plain Ruby hashes, auto-serialized to JSON via `.to_json`.

```ruby
Redwing.routes do
  get "/hello" do
    { message: "Hello" }
  end
end
```

### Project structure

Generated `api` projects follow this convention:

```
<name>/
  Gemfile
  README.md
  config/
    redwing.yml    # project type marker (type: api)
    routes.rb      # route definitions — server entry point
```

### Server boot

`redwing server` loads `config/routes.rb` from the working directory before starting Puma. No `config.ru` — redwing owns its boot process.

### JSON response

All `api` routes return `application/json` content-type automatically. Hash returns are serialized with `.to_json`. Unmatched routes return `404 {"error":"Not Found"}`.

### Rationale

- Flat DSL avoids class overhead — YAGNI at this stage
- `Redwing.routes` block keeps the DSL namespaced without polluting global scope
- `config/routes.rb` is familiar to Rails developers
- No `config.ru` — the framework abstracts Rack plumbing from users
- `config/redwing.yml` records the project type so the runtime can vary behavior (e.g. JSON vs HTML defaults)

## Consequences

### Positive

- Minimal boilerplate — four files for a working API
- Convention-driven — no manual wiring needed
- Room to evolve toward class-based routes later without breaking the DSL

### Negative

- No `config.ru` means users can't use standard Rack tooling (e.g. `rackup`) directly
- Flat DSL may not scale well for large APIs — acceptable for now, class-based routes can be introduced when needed

## Alternatives Considered

1. **Class-based routes** (`class HelloRoute < Redwing::Route`): better isolation and testability per route, but over-engineered for v0.0.5
2. **Sinatra-style top-level DSL** (no `Redwing.routes` wrapper): pollutes global namespace
3. **`config.ru` as entry point**: standard Rack convention, but redwing should own its boot process
4. **Application class** (`class MyApp < Redwing::Application`): Rails pattern, deferred until there's a concrete need for per-app state or middleware stacks
