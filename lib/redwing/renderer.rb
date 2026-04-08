# frozen_string_literal: true

require 'erb'

module Redwing
  class Renderer
    def render(template, locals = {})
      views_root = Redwing.config.views_root
      content = render_template("#{views_root}/#{template}.html.erb", locals)
      render_layout(content, locals, views_root)
    end

    private

    def render_template(path, locals)
      erb = ERB.new(File.read(path))
      RenderContext.new(locals).render_with(erb)
    end

    def render_layout(content, locals, views_root)
      erb = ERB.new(File.read("#{views_root}/layouts/application.html.erb"))
      RenderContext.new(locals).render_with(erb) { content }
    end

    class RenderContext
      def initialize(locals = {})
        locals.each { |k, v| define_singleton_method(k) { v } }
      end

      def render_with(erb, &)
        erb.result(binding)
      end
    end
  end
end
