# ADR-0008: Controller Layer and Dispatcher

## Status

Accepted (supersedes ADR-0007 for `to:` routes)

## Context

As redwing apps grow, route handlers accumulate business logic, rendering calls, and response formatting directly inside
`routes.rb` blocks. Even a small app produced a cluttered routes file — route definitions mixed with data access, file
I/O, and HTML construction.

ADR-0007 introduced `RouteContext` as the `instance_eval` target for block-based route handlers. This works well for
simple cases but offers no path toward separating route declaration from request handling.

## Decision

Introduce three components:

- **`Redwing::Controller`** — base class for user-defined controllers. Provides `render` and `params`.
- **`Redwing::Dispatcher`** — resolves and dispatches both block-based and controller-based routes. Extracted from
  `Server` to keep it thin and testable.
- **`to:` route syntax** — routes can map to a controller action: `get '/status', to: 'status#show'`. A `root` helper
  declares the root route: `root to: 'home#index'` (available but not used in the generated app).

`RouteContext` now inherits from `Controller`, eliminating interface duplication while preserving block-based route
behavior.

Controller resolution follows a fixed convention: `'status#show'` resolves to `StatusController#show` at dispatch time.
The Dispatcher validates that resolved classes inherit from `Redwing::Controller`.

Controllers are autoloaded from `app/controllers/**/*_controller.rb` at server boot via `Redwing.load_controllers`.

Additionally, `redwing new` is simplified to generate a minimal API app (StatusController + `GET /status`). Views,
layouts, and homepage are deferred to scaffold generators. The `--api` flag is removed.

### Rationale

- Route files should declare intent, not contain logic
- Convention-based autoloading eliminates manual requires without configuration
- Inheriting `RouteContext` from `Controller` consolidates the interface without changing block route behavior

## Consequences

### Positive

- Clear separation of routing and request handling
- Dispatcher is independently testable — no Rack/Puma dependency
- `redwing new` produces a lighter, API-first starting point
- Block-based routes still work unchanged
- Single interface definition shared by Controller and RouteContext

### Negative

- Two dispatch paths (block + controller) add complexity to the Dispatcher — acceptable trade-off since blocks remain
  useful for simple one-liners

## Alternatives Considered

1. **Merge Controller into RouteContext**: Rejected — reversed the relationship instead; RouteContext inherits from
   Controller
2. **Resolve controller at route definition time**: Rejected — controllers may not be loaded when routes are defined
3. **Inline dispatch in Server**: Rejected — Dispatcher as a separate class keeps Server thin and enables isolated
   testing
4. **Configurable controller paths**: Rejected (YAGNI) — convention of `app/controllers/` is sufficient until a real use
   case arises

## References

- ADR-0007: RouteContext as instance_eval Target (still applies to block-based routes; RouteContext now inherits from
  Controller)
