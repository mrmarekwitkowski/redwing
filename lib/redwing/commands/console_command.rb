# frozen_string_literal: true

require 'redwing/version'
require 'redwing/command/base_command'

module Redwing
  module Commands
    class ConsoleCommand < Command::BaseCommand
      no_commands do
        def perform
          app_file = File.join(Dir.pwd, 'config', 'application.rb')
          load app_file if File.exist?(app_file)

          puts "Redwing #{Redwing::VERSION} console (#{RUBY_ENGINE} #{RUBY_VERSION})"

          begin
            require 'pry'
            Pry.start
          rescue LoadError
            require 'irb'
            IRB.start(__FILE__)
          end
        end
      end
    end
  end
end
