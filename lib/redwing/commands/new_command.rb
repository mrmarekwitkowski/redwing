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

      VIEW_TEMPLATES = %w[
        app/views/layouts/application.html.erb
        app/views/home/index.html.erb
      ].freeze

      argument :name, required: true, type: :string
      class_option :api, type: :boolean, default: false, desc: 'Generate an API-only app'

      no_commands do
        def perform
          target_path = "#{Pathname.pwd}/#{app_name}"
          data = {name: app_name}

          scaffold_templates(TEMPLATES, target_path, data)

          return if api_only?

          scaffold_templates(VIEW_TEMPLATES, target_path, data)
        end

        def app_name
          @name
        end

        def api_only?
          options[:api]
        end

        def scaffold_templates(templates, target_path, data)
          templates.each do |template_name|
            Generator.create_file_by_template("templates/#{template_name}.tt", "#{target_path}/#{template_name}", data)
          end
        end
      end
    end
  end
end
