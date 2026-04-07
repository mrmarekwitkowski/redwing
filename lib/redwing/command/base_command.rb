# frozen_string_literal: true

require 'thor'
require 'thor/actions'

module Redwing
  module Command
    class BaseCommand < Thor
      include Thor::Actions
    end
  end
end
