# frozen_string_literal: true

module Redwing
  class Router
    SUPPORTED_METHODS = %w[GET POST PUT PATCH DELETE].freeze

    attr_reader :routes

    def initialize
      @routes = []
    end

    SUPPORTED_METHODS.each do |verb|
      define_method(verb.downcase) do |path, to: nil, &block|
        raise ArgumentError, 'provide either a block or to:, not both' if to && block
        raise ArgumentError, 'provide a block or to:' unless to || block

        route = {method: verb, path: path}
        route[:handler] = block if block
        route[:to] = to if to
        @routes << route
      end
    end

    def root(to:)
      raise ArgumentError, 'root route already defined' if @routes.any? { |r| r[:path] == '/' }

      @routes << {method: 'GET', path: '/', to: to}
    end

    def match(method, path)
      routes.find { |r| r[:method] == method && r[:path] == path }
    end
  end
end
