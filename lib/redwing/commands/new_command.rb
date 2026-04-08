# frozen_string_literal: true

require 'pathname'

require 'redwing/command/base_command'
require 'redwing/generator'

module Redwing
  module Commands
    class NewCommand < Command::BaseCommand
      TEMPLATES = %w[
        README.md
        Gemfile
        config/routes.rb
      ].freeze

      argument :name, required: true, type: :string
      class_option :api, type: :boolean, default: false, desc: 'Generate an API-only app'

      no_commands do
        def perform
          target_path = "#{Pathname.pwd}/#{app_name}"
          data = {name: app_name}

          TEMPLATES.each do |template_name|
            template = "templates/#{template_name}.tt"
            destination = "#{target_path}/#{template_name}"
            Generator.create_file_by_template(template, destination, data)
          end
        end

        def app_name
          @name
        end

        def api_only?
          options[:api]
        end
      end
    end
  end
end
