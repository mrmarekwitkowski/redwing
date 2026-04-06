# frozen_string_literal: true

require 'rack'
require 'rackup'

module Redwing
  module Server
    def self.start(host:, port:)
      app = proc do |env|
        _request = Rack::Request.new(env)
        [200, {}, ['hello world']]
      end

      handler = Rackup::Handler.get('puma')
      handler.run(app, Host: host, Port: port)
    end
  end
end
