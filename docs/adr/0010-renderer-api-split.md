# ADR-0010: Renderer API — Split Over `layout:` Kwarg

## Status

Accepted

Relates to ADR-0005 (ERB Rendering and Layout System).

## Context

A transient design (commit `aae771c`, "support layout-less rendering") added a `layout:` keyword argument to
`Renderer#render`, giving the signature `render(template, locals = {}, layout: true)`. In Ruby 3, trailing hash literals
at call sites are promoted to keyword arguments when the method defines any kwargs. That meant `render 'home/index',
title: 'Welcome'` raised `ArgumentError: unknown keyword: :title` because `title:` was routed to the kwargs slot instead
of the positional `locals` hash.

Every caller had to opt out of natural Ruby syntax with explicit `{...}` wraps. `verify_partial_doubles` in RSpec also
flagged the kwargs/hash mismatch, pushing the noise into the test suite.

Meanwhile, fragment responses (HTMX-style partial swaps, JSON embedded HTML snippets) are a common real use case that
deserves a first-class API, not a boolean flag.

## Decision

Remove the `layout:` kwarg. Expose two explicit methods on `Renderer`:

- `render(template, locals = {})` — renders the template and wraps it in the application layout
- `render_without_layout(template, locals = {})` — renders the template alone

`RenderContext#render(template, locals = {})` — the context in which ERB templates execute — now also exposes a
`render` method so that templates can embed nested partials (`<%= render 'home/greeting' %>`).

`Controller` exposes both methods as named forwarders.

### Rationale

- One method per mode eliminates the Ruby 3 kwargs/hash ambiguity at every call site
- The method name communicates intent (`render_without_layout`) — no flag to look up
- Parallels `RenderContext#render`, which is already layout-less by nature
- Named controller forwarders (instead of `def render(...) = @renderer.render(...)`) let `verify_partial_doubles`
  introspect the signature, so mocks work cleanly

## Consequences

### Positive

- `render 'home/index', title: 'Welcome'` works without hash braces again
- Fragment rendering is a first-class, self-documenting API call
- Mock expectations with `instance_double(Redwing::Renderer)` match the real signature
- Nested partials inside templates are supported

### Negative

- Slightly larger API surface: two methods instead of one with a flag
- Callers pick the right method up front — there is no runtime toggle

## Alternatives Considered

1. **`render(template, locals: {}, layout: true)` with an explicit `locals:` kwarg**: removes the ambiguity but makes
   every call verbose (`render 'home/index', locals: {title: 'Welcome'}`)
2. **`render(template, **opts)` extracting `:layout` internally**: concise at the call site but magic; also collides if
   a user has a local variable literally named `layout`
3. **Keep `{...}` wraps at every call site**: the status quo we rejected — ergonomics toll on every caller, every
   template, every mock

## Implementation

- `lib/redwing/renderer.rb` — two top-level methods plus the pre-existing private `render_template` /
  `render_layout` helpers
- `Renderer::RenderContext#render(template, locals = {})` renders nested partials from within templates
- `lib/redwing/controller.rb` — named forwarders:
  ```ruby
  def render(template, locals = {}) = @renderer.render(template, locals)
  def render_without_layout(template, locals = {}) = @renderer.render_without_layout(template, locals)
  ```

## References

- `lib/redwing/renderer.rb`
- `lib/redwing/controller.rb`
- Related: ADR-0003 (Template Variable Binding), ADR-0005 (ERB Rendering and Layout), ADR-0007 (RouteContext),
  ADR-0008 (Controller Layer)
