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
        app/controllers/status_controller.rb
      ].freeze

      argument :name, required: true, type: :string

      no_commands do
        def perform
          target_path = "#{Pathname.pwd}/#{app_name}"
          data = {name: app_name}

          scaffold_templates(TEMPLATES, target_path, data)
        end

        def app_name
          @name
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
