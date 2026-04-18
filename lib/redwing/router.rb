# frozen_string_literal: true

module Redwing
  class Router
    SUPPORTED_METHODS = %w[GET POST PUT PATCH DELETE].freeze
    PARAM_PATTERN = %r{:([A-Za-z_][A-Za-z0-9_]*)}

    attr_reader :routes

    def initialize
      @routes = []
    end

    SUPPORTED_METHODS.each do |verb|
      define_method(verb.downcase) do |path, to: nil, &block|
        raise ArgumentError, 'provide either a block or to:, not both' if to && block
        raise ArgumentError, 'provide a block or to:' unless to || block

        route = {method: verb, path: path, matcher: compile(path)}
        route[:handler] = block if block
        route[:to] = to if to
        @routes << route
      end
    end

    def root(to:)
      raise ArgumentError, 'root route already defined' if @routes.any? { |r| r[:path] == '/' }

      @routes << {method: 'GET', path: '/', to: to, matcher: compile('/')}
    end

    def match(method, path)
      routes.each do |route|
        next unless route[:method] == method

        match_data = route[:matcher].match(path)
        next unless match_data

        return {route: route, params: match_data.named_captures}
      end
      nil
    end

    private

    def compile(path)
      escaped = Regexp.escape(path)
      pattern = escaped.gsub(PARAM_PATTERN) { "(?<#{Regexp.last_match(1)}>[^/]+)" }
      Regexp.new("\\A#{pattern}\\z")
    end
  end
end
