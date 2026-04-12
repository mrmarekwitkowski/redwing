# frozen_string_literal: true

module Redwing
  class Controller
    def initialize(request)
      @request = request
      @renderer = Renderer.new
    end

    def render(...) = @renderer.render(...)

    def params
      @request&.params || {}
    end
  end
end
