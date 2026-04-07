# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'redwing/version'

module Redwing
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Generator
  autoload :Router

  def self.routes(&block)
    @router ||= Router.new
    @router.instance_eval(&block) if block
    @router
  end

  def self.reset_routes!
    @router = nil
  end
end
