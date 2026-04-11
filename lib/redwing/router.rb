# frozen_string_literal: true

module Redwing
  class Router
    SUPPORTED_METHODS = %w[GET POST PUT PATCH DELETE].freeze

    attr_reader :routes

    def initialize
      @routes = []
    end

    SUPPORTED_METHODS.each do |verb|
      define_method(verb.downcase) do |path, &block|
        @routes << {method: verb, path: path, handler: block}
      end
    end

    def match(method, path)
      routes.find { |r| r[:method] == method && r[:path] == path }
    end
  end
end
