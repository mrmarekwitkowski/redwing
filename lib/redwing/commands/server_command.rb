# frozen_string_literal: true

require 'redwing/server'
require 'redwing/command/base_command'

module Redwing
  module Commands
    class ServerCommand < Command::BaseCommand
      class_option :host, type: :string,  default: 'localhost', aliases: '-b', desc: 'Bind to host'
      class_option :port, type: :numeric, default: 3001,        aliases: '-p', desc: 'Listen on port'

      no_commands do
        def perform
          Redwing::Server.start(host: options[:host], port: options[:port])
        end
      end
    end
  end
end
