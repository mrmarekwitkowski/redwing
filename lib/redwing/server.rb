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
          body = route[:handler].call
          [200, { "content-type" => "application/json" }, [body.to_json]]
        else
          [404, { "content-type" => "application/json" }, ['{"error":"Not Found"}']]
        end
      end

      handler = Rackup::Handler.get('puma')
      handler.run(app, Host: host, Port: port)
    end
  end
end
