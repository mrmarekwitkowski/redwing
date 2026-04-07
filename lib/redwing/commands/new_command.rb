# frozen_string_literal: true

require 'pathname'

require 'redwing/command/base_command'
require 'redwing/generator'

module Redwing
  module Commands
    class NewCommand < Command::BaseCommand
      VALID_APP_TYPES = %w[api web].freeze

      argument :type, required: true, values: %w[api web]
      argument :name, required: true, type: :string

      no_commands do
        def perform
          raise ArgumentError, "Invalid app type '#{app_type}'. Valid types: #{VALID_APP_TYPES.join(', ')}" unless VALID_APP_TYPES.include?(app_type)

          target_path = "#{Pathname.pwd}/#{app_name}"
          template_name = 'README.md'

          Generator.create_file_by_template("templates/#{template_name}", "#{target_path}/#{template_name}", {name: app_name})
        end

        def app_type
          @type
        end

        def app_name
          @name
        end
      end
    end
  end
end
