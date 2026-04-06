# frozen_string_literal: true

require 'thor'

module Redwing
  module Commands
    class ConsoleCommand < Thor
      desc 'console', 'Start an interactive console (Pry or IRB)'

      def console
        exec File.join(APP_ROOT, 'bin', 'console')
      end

      default_task :console
    end
  end
end
