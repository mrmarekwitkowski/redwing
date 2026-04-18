# frozen_string_literal: true

module Redwing
  class Controller
    def initialize(request, path_params = {})
      @request = request
      @path_params = path_params
      @renderer = Renderer.new
    end

    def render(template, locals = {}) = @renderer.render(template, locals)
    def render_without_layout(template, locals = {}) = @renderer.render_without_layout(template, locals)

    def params
      (@request&.params || {}).merge(@path_params || {})
    end
  end
end
