# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'redwing/version'

module Redwing
  extend ActiveSupport::Autoload

  autoload :Generator
end
