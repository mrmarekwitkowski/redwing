# frozen_string_literal: true

require 'thor'
require 'redwing/version'

module Redwing
  module Commands
    class ConsoleCommand < Thor
      desc 'console', 'Start an interactive Redwing console'

      def console
        app_root = Dir.pwd
        app_file = File.join(app_root, 'config', 'application.rb')
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

      default_task :console
    end
  end
end
