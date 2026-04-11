# ADR-0007: RouteContext as instance_eval Target

## Status

Accepted

## Context

ADR-0005 established `Renderer` as the `instance_eval` target for route handlers, making `render` available
inside route blocks. When POST support was added and route handlers needed access to request params, the
question arose: where does `params` live?

Adding `params` to `Renderer` would give it two unrelated responsibilities — rendering templates and
accessing request data — violating the Single Responsibility Principle.

## Decision

Introduce `Redwing::RouteContext` as the dedicated `instance_eval` target for route handlers.

`RouteContext` composes a `Renderer` instance and a `Rack::Request`, and exposes two methods:

- `render(...)` — delegates to `Renderer`
- `params` — delegates to `Rack::Request#params`

`Server` instantiates a new `RouteContext` per request and evaluates the route handler against it.

### Rationale

- `Renderer` returns to a single responsibility: template rendering
- `RouteContext` is the natural extension point for future handler capabilities (e.g. redirects, cookies, headers)
- Composition over inheritance — no subclassing of `Renderer`

## Consequences

### Positive

- `render` and `params` are both available inside route blocks without coupling concerns
- `Renderer` remains pure — no request knowledge
- `RouteContext` is the single place to extend route handler capabilities

### Negative

- One additional class to understand: `render` and `params` inside route blocks are not global methods but
  methods on a context object set invisibly as `self` via `instance_eval` — without knowing `RouteContext`
  exists, the DSL reads like magic
- `instance_eval` changes `self` inside route blocks, making outer-scope instance variables and methods
  silently inaccessible (inherited limitation from ADR-0005; `RouteContext` does not worsen it)

## Alternatives Considered

1. **Add `params` to `Renderer`**: Rejected — violates SRP; `Renderer` should not know about requests
2. **Explicit block parameter (`do |ctx|`)**: Rejected for now — preserves outer scope but breaks the
   Rails-like DSL feel; worth revisiting if the `instance_eval` footgun becomes a real problem
3. **`method_missing` delegation to outer scope**: Rejected — fragile, slow, and produces confusing errors

## References

- ADR-0005: ERB Rendering and Layout System (partially superseded — `instance_eval` target changed from
  `Renderer` to `RouteContext`)
