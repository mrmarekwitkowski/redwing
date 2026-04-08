# ADR-0005: ERB Rendering and Layout System

## Status

Accepted

## Context

Redwing needs to serve HTML responses alongside JSON. This requires an ERB rendering engine that supports a base layout
wrapping view templates — similar to Rails' `application.html.erb` + `yield` pattern.

## Decision

Introduce `Redwing::Renderer` with two responsibilities:

1. Render a named ERB template from `views_root`
2. Wrap the rendered content in a layout using `yield`

Views follow the convention `<views_root>/<template>.html.erb`. The layout lives at
`<views_root>/layouts/application.html.erb`.

`Renderer` is instantiated per request in `server.rb`. Route handlers are evaluated via `instance_eval` on the renderer
instance, making `render` available inside route blocks without polluting global scope.

### Rationale

- `instance_eval` keeps `render` scoped to `Renderer` — no global method pollution
- `RenderContext` is used to evaluate ERB templates in a clean binding, with locals injected via
  `define_singleton_method`
- `yield` in layouts works by calling the block passed to `RenderContext#render_with` — ERB compiles `<%= yield %>` to a
  literal `yield` expression, which delegates to the block
- `views_root` is read from `Redwing.config` at render time, making it configurable without touching `Renderer`

## Consequences

### Positive

- `render "template/name"` works naturally inside route blocks
- Layout wrapping via `yield` is idiomatic Ruby/Rails
- Views root is configurable via `Redwing.config.views_root`

### Negative

- `instance_eval` changes `self` inside route blocks — any instance variables or methods defined in the block's original
  scope are no longer accessible
- Single layout only — multiple layouts not yet supported

## Alternatives Considered

1. **Global `render` method**: Pollutes global namespace, rejected
2. **`content` local variable instead of `yield`**: Simpler but non-idiomatic; `yield` was preferred to match Rails
   conventions
3. **`binding`-based locals**: Replaced by `RenderContext` with `define_singleton_method` to avoid `build_binding`
   fragility across Ruby versions
