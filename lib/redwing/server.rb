# frozen_string_literal: true

require 'json'
require 'rack'
require 'rackup'
require 'redwing'

module Redwing
  module Server
    class GetOnlyStatic
      def initialize(app, **opts)
        @static = Rack::Static.new(app, **opts)
        @app = app
      end

      def call(env)
        if %w[GET HEAD].include?(env['REQUEST_METHOD'])
          @static.call(env)
        else
          @app.call(env)
        end
      end
    end

    def self.start(host:, port:)
      Redwing.load_controllers

      app = proc do |env|
        request = Rack::Request.new(env)
        match = Redwing.routes.match(request.request_method, request.path_info)

        if match
          dispatcher = Redwing::Dispatcher.new
          body = dispatcher.call(match[:route], request, match[:params])

          response = case body
                     when Hash
                       [200, {'content-type' => 'application/json'}, [body.to_json]]
                     when String
                       [200, {'content-type' => 'text/html; charset=utf-8'}, [body]]
                     else
                       raise Redwing::Error::InvalidResponse,
                             "Route handler must return a Hash or String, got #{body.class}"
                     end

          Redwing.config.logger.info("#{request.request_method} #{request.path_info} => #{response[0]}")
          response
        else
          Redwing.config.logger.info("#{request.request_method} #{request.path_info} => 404")
          [404, {'content-type' => 'application/json'}, ['{"error":"Not Found"}']]
        end
      end

      wrapped = Rack::Builder.new do
        use GetOnlyStatic, urls: [''], root: Redwing.config.public_root, cascade: true
        run app
      end

      handler = Rackup::Handler.get('puma')
      handler.run(wrapped, Host: host, Port: port)
    end
  end
end
