# frozen_string_literal: true

require 'pathname'

require 'redwing/command/base_command'
require 'redwing/generator'

module Redwing
  module Commands
    class NewCommand < Command::BaseCommand
      VALID_APP_TYPES = %w[api web].freeze
      TEMPLATES = %w[
        README.md
        Gemfile
        config/redwing.yml
        config/routes.rb
      ].freeze

      argument :type, required: true, values: %w[api web]
      argument :name, required: true, type: :string

      no_commands do
        def perform
          validate!

          target_path = "#{Pathname.pwd}/#{app_name}"
          data = {name: app_name, type: app_type}

          TEMPLATES.each do |template_name|
            template = "templates/#{template_name}.tt"
            destination = "#{target_path}/#{template_name}"
            Generator.create_file_by_template(template, destination, data)
          end
        end

        def app_type
          @type
        end

        def app_name
          @name
        end

        def validate!
          raise ArgumentError, "Invalid app type '#{app_type}'. Valid types: #{valid_app_types}" unless valid_app_type?
        end

        def valid_app_type?
          VALID_APP_TYPES.include?(app_type)
        end

        def valid_app_types
          VALID_APP_TYPES.join(', ')
        end
      end
    end
  end
end
