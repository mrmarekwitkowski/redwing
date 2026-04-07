# frozen_string_literal: true

require_relative 'generator/file_by_template'

module Redwing
  module Generator
    def create_file_by_template(template, destination, config = {})
      FileByTemplate.start([template, destination, config])
    end

    module_function :create_file_by_template
  end
end
