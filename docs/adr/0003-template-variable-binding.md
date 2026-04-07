# ADR-0003: Template Variable Binding via Singleton Methods

## Status

Accepted

## Context

The generator engine (`FileByTemplate`) is a generic ERB renderer. It receives template
variables as a `data` hash (e.g. `{name: "my-app", type: "api"}`). Templates need access
to these variables for interpolation.

## Decision

Expose `data` hash keys as singleton methods on the generator instance before rendering:

```ruby
data.each { |k, v| define_singleton_method(k) { v } }
template(source, destination)
```

This makes variables available directly in ERB templates as method calls (e.g. `<%= name %>`).

## Consequences

### Positive

- Clean, readable template syntax (`<%= name %>` vs `<%= data[:name] %>`)
- `FileByTemplate` stays generic — no knowledge of specific variables per command
- Typos in variable names raise `NoMethodError` instead of returning nil silently

### Negative

- Dynamic method definition is less explicit than named accessors
- Key names must be valid Ruby method names

## Alternatives Considered

1. **Named `argument` accessors on `FileByTemplate`**: explicit but couples the generic
   renderer to per-command variable names — rejected
2. **`data[:key]` access directly in templates**: works but verbose and silently returns
   nil on typos — rejected
