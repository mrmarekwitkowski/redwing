# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module Redwing
  class Dispatcher
    def call(route, request)
      if route[:handler]
        RouteContext.new(request).instance_eval(&route[:handler])
      elsif route[:to]
        controller_class, action = resolve(route[:to])
        controller_class.new(request).public_send(action)
      end
    end

    private

    def resolve(to)
      controller_name, action = to.split('#')
      klass = Object.const_get("#{controller_name.camelize}Controller")

      raise ArgumentError, "#{klass} must inherit from Redwing::Controller" unless klass < Redwing::Controller

      [klass, action.to_sym]
    end
  end
end
