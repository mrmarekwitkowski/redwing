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

          if body.is_a?(Hash)
            [200, {'content-type' => 'application/json'}, [body.to_json]]
          else
            [200, {'content-type' => 'text/html'}, [body.to_s]]
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
