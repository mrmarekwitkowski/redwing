# frozen_string_literal: true

require 'json'
require 'rack'
require 'rackup'
require 'redwing'

module Redwing
  module Server
    def self.start(host:, port:)
      app = proc do |env|
        request = Rack::Request.new(env)
        route = Redwing.routes.match(request.request_method, request.path_info)

        if route
          renderer = Redwing::Renderer.new
          body = renderer.instance_eval(&route[:handler])

          case body
          when Hash
            [200, {'content-type' => 'application/json'}, [body.to_json]]
          when String
            [200, {'content-type' => 'text/html'}, [body]]
          else
            raise Redwing::Error::InvalidResponse,
              "Route handler must return a Hash or String, got #{body.class}"
          end
        else
          [404, {'content-type' => 'application/json'}, ['{"error":"Not Found"}']]
        end
      end

      handler = Rackup::Handler.get('puma')
      handler.run(app, Host: host, Port: port)
    end
  end
end
