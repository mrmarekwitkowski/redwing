# frozen_string_literal: true

require 'json'
require 'rack'
require 'rackup'
require 'redwing'

module Redwing
  module Server
    def self.start(host:, port:)
      Redwing.load_controllers
      not_found = [404, {'content-type' => 'application/json'}, ['{"error":"Not Found"}']]

      static = Rack::Static.new(
        ->(_env) { not_found },
        urls: [''], root: Redwing.config.public_root, cascade: true
      )

      app = proc do |env|
        request = Rack::Request.new(env)
        match = Redwing.routes.match(request.request_method, request.path_info)

        response =
          if match
            dispatcher = Redwing::Dispatcher.new
            body = dispatcher.call(match[:route], request, match[:params])

            case body
            when Hash   then [200, {'content-type' => 'application/json'}, [body.to_json]]
            when String then [200, {'content-type' => 'text/html; charset=utf-8'}, [body]]
            else raise Redwing::Error::InvalidResponse,
                       "Route handler must return a Hash or String, got #{body.class}"
            end
          elsif %w[GET HEAD].include?(request.request_method)
            static.call(env)
          else
            not_found
          end

        Redwing.config.logger.info("#{request.request_method} #{request.path_info} => #{response[0]}")
        response
      end

      handler = Rackup::Handler.get('puma')
      handler.run(app, Host: host, Port: port)
    end
  end
end
