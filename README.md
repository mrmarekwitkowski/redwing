# redwing

Sometimes, all you need is a little server. That´s `redwing` for you. What you make out of it, is up to you.

## Quick Start

```bash
gem install redwing
redwing new api my-api
cd my-api
redwing server
```

Then visit `http://localhost:3001/hello`.

## What you get

```
my-api/
  Gemfile
  README.md
  config/
    redwing.yml
    routes.rb
```

### Define routes

```ruby
# config/routes.rb
Redwing.routes do
  get '/hello' do
    {message: 'Hello from my-api'}
  end
end
```

Hash returns are auto-serialized to JSON.

## Requirements

- Ruby 3.4+
