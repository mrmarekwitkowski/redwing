# redwing

Sometimes, all you need is a little server. That´s `redwing` for you. What you make out of it, is up to you.

## Quick Start

```bash
gem install redwing
redwing new my-app
cd my-app
redwing server
```

Then visit `http://localhost:3001/`.

## What you get

```
my-app/
  Gemfile
  README.md
  app/
    views/
      home/
        index.html.erb
      layouts/
        application.html.erb
  config/
    routes.rb
```

### Define routes

```ruby
# config/routes.rb
Redwing.routes do
  get '/' do
    render 'home/index'
  end
end
```

HTML responses are rendered via ERB. Hash returns are auto-serialized to JSON.

## API-only app

```bash
redwing new my-api --api
```

Skips view scaffolding. Routes return JSON:

```ruby
Redwing.routes do
  get '/hello' do
    {message: 'Hello from my-api'}
  end
end
```

## Configuration

```ruby
# config/routes.rb
Redwing.configure do |config|
  config.views_root = 'app/views'       # default
  config.log_file   = 'log/redwing.log' # default (production)
end
```

## Requirements

- Ruby 3.4+
