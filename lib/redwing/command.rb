# frozen_string_literal: true

require 'redwing/commands/console_command'
require 'redwing/commands/server_command'

module Redwing
  module Command
    COMMAND_WHITELIST = {
      console: %w[console c],
      server: %w[server s]
    }.freeze

    def self.invoke(argv)
      command_name = COMMAND_WHITELIST.find { |_, aliases| aliases.include?(argv.first) }&.first
      args = argv.drop(1)

      case command_name
      when :console
        Redwing::Commands::ConsoleCommand.start(args)
      when :server
        Redwing::Commands::ServerCommand.start(args)
      else
        warn "Unknown command: #{argv.first}"
        exit(1)
      end
    end
  end
end
