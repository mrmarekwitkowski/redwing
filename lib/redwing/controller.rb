# frozen_string_literal: true

module Redwing
  class Controller
    def initialize(request, path_params = {})
      @request = request
      @path_params = path_params
      @renderer = Renderer.new
    end

    def render(...) = @renderer.render(...)

    def params
      (@request&.params || {}).merge(@path_params || {})
    end
  end
end
