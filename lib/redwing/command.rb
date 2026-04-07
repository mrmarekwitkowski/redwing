# frozen_string_literal: true

require_relative 'errors'
require_relative 'command/base_command'

require 'redwing/commands/console_command'
require 'redwing/commands/new_command'
require 'redwing/commands/server_command'

module Redwing
  module Command
    COMMAND_WHITELIST = {
      console: %w[console c],
      server: %w[server s],
      new: %w[new]
    }.freeze

    VERSION_MAPPINGS = %w[-v --version].to_set

    class << self
      attr_reader :argv, :args

      def execute(argv)
        return puts Redwing::VERSION if VERSION_MAPPINGS.include?(argv.first)

        @argv = argv
        @args = @argv.drop(1)

        raise Error::UnknownCommand, "Unknown command: #{@argv.first}" if command_klass.nil?

        exec_klass = command_klass.new(@args, command_options)
        raise Error::PerformNotImplemented, "#{exec_klass.class} does not implement #perform" unless exec_klass.respond_to?(:perform)

        trap_interrupt!
        exec_klass.perform

        exit_ok!
      rescue StandardError => e
        shell.say(e.message)

        exit_failed!
      end

      def reset!
        @argv = nil
        @args = nil
        @command_name = nil
        @command_klass = nil
      end

      def command_name
        @command_name ||= COMMAND_WHITELIST.find { |_, aliases| aliases.include?(@argv.first) }&.first
      end

      def command_klass
        @command_klass ||= {
          console: Redwing::Commands::ConsoleCommand,
          new: Redwing::Commands::NewCommand,
          server: Redwing::Commands::ServerCommand
        }[command_name]
      end

      private

      def shell
        @shell ||= Thor::Base.shell.new
      end

      def command_options
        Thor::Options.new(
          command_klass.class_options,
          {},
          stop_on_unknown_option?,
          disable_required_check?,
          command_options_relation
        ).parse(@args)
      end

      def stop_on_unknown_option?
        false
      end

      def disable_required_check?
        return true if %w[-h --help].include?(@argv.first)

        command_klass.disable_required_check? command_klass
      end

      def command_options_relation
        {exclusive_option_names: [], at_least_one_option_names: []}
      end

      def exit_ok!
        Kernel.exit(0)
      end

      def exit_failed!
        Kernel.exit(1)
      end

      def exit_unable_to_finish!
        Kernel.exit(2)
      end

      def trap_interrupt!
        Signal.trap('INT') do
          shell.say("\nExiting... Interrupt again to exit immediately.")
          exit_unable_to_finish!
        end
      end
    end
  end
end
