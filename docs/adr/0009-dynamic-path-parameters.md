# ADR-0009: Dynamic Path Parameters

## Status

Accepted

## Context

The router originally matched only literal paths via string equality. Real applications need parameterized routes (e.g.
`/users/:id`, `/users/:id/posts/:post_id`) so handlers can respond to a family of URLs and extract segment values.

## Decision

Support colon-prefixed path segments as named parameters. At route registration the path is compiled into an anchored
regex with named capture groups; `Router#match` scans routes linearly and returns `{route:, params:}` on a hit, where
`params` is a hash of captured segments. Controllers receive path params through their constructor and merge them into
`#params` alongside the request params.

### Rationale

- `:name` is the Rails/Sinatra convention and reads naturally in Ruby route DSLs
- Compile-once-match-many avoids recompiling the regex on every request
- `MatchData#named_captures` extracts params cleanly without manual index bookkeeping
- Returning a `{route:, params:}` hash (instead of just a route) keeps the call site symmetric and avoids mutating the
  route hash at dispatch time

## Consequences

### Positive

- Familiar parameterized routing syntax
- Path params surface in both block handlers (via route context) and controller actions
- Registration-time compilation, not per-request

### Negative

- Route matching is O(n) over all registered routes — no trie, no radix lookup
- No type coercion — captured segments are always strings
- Path params override same-named request params on conflict (documented, not accidental)

## Alternatives Considered

1. **`{param}` syntax (FastAPI-style)**: less idiomatic in Ruby web frameworks; rejected for familiarity
2. **Split-based segment matching**: matches the simple case but awkward to extend to wildcards or optional segments
3. **Full regex in route definitions**: too powerful; most users want named segments, not raw regex

## Implementation

- `Router::PARAM_PATTERN = %r{:([A-Za-z_][A-Za-z0-9_]*)}`
- `Router#compile(path)` escapes the literal, substitutes each `:name` with `(?<name>[^/]+)`, anchors with `\A` and `\z`
- `Router#match` iterates `@routes` and returns the first `{route:, params:}` whose matcher anchors against the path
- `Controller#initialize(request, path_params = {})` stores `@path_params`
- `Controller#params` returns `request_params.merge(@path_params)` — path params win on collision

## References

- `lib/redwing/router.rb`
- `lib/redwing/controller.rb`
- Related: ADR-0004 (API Routing), ADR-0008 (Controller Layer)
