# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'redwing/version'

module Redwing
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Generator
  autoload :Logger
  autoload :Renderer
  autoload :Router

  def self.configure
    yield config
  end

  def self.config
    @config ||= Config.new
  end

  def self.routes(&block)
    @router ||= Router.new
    @router.instance_eval(&block) if block
    @router
  end

  def self.reset_routes!
    @router = nil
  end
end
