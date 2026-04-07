# frozen_string_literal: true

require 'thor/group'
require 'thor/actions'

module Redwing
  module Generator
    class BaseGenerator < Thor::Group
      include Thor::Actions
    end

    class FileByTemplate < BaseGenerator
      argument :source, type: :string
      argument :destination, type: :string
      argument :data, type: :hash, default: {}

      def self.source_root
        File.dirname(__FILE__)
      end

      def create
        data.each { |k, v| define_singleton_method(k) { v } }
        template(source, destination)
      end
    end
  end
end
