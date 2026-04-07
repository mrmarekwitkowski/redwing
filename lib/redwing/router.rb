# frozen_string_literal: true

module Redwing
  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    def get(path, &block)
      @routes << { method: "GET", path: path, handler: block }
    end
  end
end
