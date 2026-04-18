# ADR-0011: Middleware Ordering — Router First, Static as GET-Only Fallback

## Status

Accepted

Relates to commit `7ea6a51` (feat(web-essentials): serve static files from public root).

## Context

The initial static-file decision placed `Rack::Static` in front of the application router with `urls: ['']` matching
every path:

```ruby
use Rack::Static, urls: [''], root: Redwing.config.public_root, cascade: true
run app
```

Two problems surfaced:

1. **POST/PUT/PATCH/DELETE returned 405.** `Rack::Static` answers non-GET/HEAD requests with 405 whenever the URL
   prefix matches, and `cascade: true` only falls through on 404 — so every write-shaped request was intercepted before
   reaching the router.
2. **Static silently shadowed routes on name collision.** If `public/home.html` existed and a route `GET /home` was
   defined, the static file won without any indication that a route had been declared.

A first patch introduced a `GetOnlyStatic` wrapper that forwarded only GET/HEAD to `Rack::Static`. That fixed the 405
symptom but left the shadowing issue in place and added middleware plumbing that duplicated responsibilities already
handled by the app proc.

## Decision

Invert the ordering. The router runs first. When no route matches:

- GET and HEAD requests are delegated to `Rack::Static`, which serves a file from `public/` or cascades to an internal
  404 responder
- All other methods return 404 directly, bypassing static entirely

Drop the `GetOnlyStatic` middleware class and the `Rack::Builder` wrap. The whole flow fits in a single app proc.

### Rationale

- Routes are the application's primary concern; static files are a fallback, not a gatekeeper
- Explicit method-check avoids `Rack::Static`'s 405 and the cascade-only-on-404 quirk
- One proc is easier to reason about than a two-layer middleware stack for the same behavior

## Consequences

### Positive

- POST/PUT/PATCH/DELETE reach the router as expected
- Routes always win over same-named static files (safer default; predictable behavior)
- `GetOnlyStatic` class and `Rack::Builder` wrap removed — simpler server code
- No more cascade semantics to reason about at the outer edge

### Negative

- Behavioral change: if any user currently relies on `public/foo` shadowing a registered `GET /foo` route, they break.
  This was undocumented behavior, not a feature.
- Static files are served only for GET/HEAD. Standard HTTP semantics — no practical downside.

## Alternatives Considered

1. **Keep `GetOnlyStatic` wrapper in front of the router**: papered over 405 but did not address route-shadowing; also
   needed extra middleware plumbing
2. **Narrow `urls:` to `/assets` or `/public` prefix**: would cleanly separate concerns but undo the "serve from public
   root" intent of commit `7ea6a51`
3. **`Rack::Cascade` with `[app, static]`**: equivalent outcome but more indirection; the app proc can express the same
   logic directly

## Implementation

- `lib/redwing/server.rb` — single app proc:
    - Build a `not_found` triple once
    - Instantiate `Rack::Static` with a 404-returning lambda as the inner app (served via `cascade: true`)
    - Inside the app proc: router match → dispatch; else if GET/HEAD → delegate to `static`; else → `not_found`
- Handler runs the app proc directly, no `Rack::Builder`

## References

- `lib/redwing/server.rb`
- Commit `7ea6a51` (original static file decision)
- Commit `b0b1880` (intermediate `GetOnlyStatic` fix, now removed)
- Commit `27e6f7c` (router-first refactor)
