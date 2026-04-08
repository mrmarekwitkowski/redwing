# frozen_string_literal: true

require 'erb'

module Redwing
  class Renderer
    VIEWS_ROOT = 'app/views'
    LAYOUT = 'app/views/layouts/application.html.erb'

    def render(template, locals = {})
      content = render_template("#{VIEWS_ROOT}/#{template}.html.erb", locals)
      render_layout(content, locals)
    end

    private

    def render_template(path, locals)
      erb = ERB.new(File.read(path))
      RenderContext.new(locals).render_with(erb)
    end

    def render_layout(content, locals)
      erb = ERB.new(File.read(LAYOUT))
      RenderContext.new(locals).render_with(erb) { content }
    end

    class RenderContext
      def initialize(locals = {})
        locals.each { |k, v| define_singleton_method(k) { v } }
      end

      def render_with(erb, &block)
        erb.result(binding)
      end
    end
  end
end
