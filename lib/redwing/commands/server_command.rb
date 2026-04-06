# frozen_string_literal: true

require 'thor'
require 'redwing/server'

module Redwing
  module Commands
    class ServerCommand < Thor
      desc 'server', 'Start the Redwing server'

      method_option :host, type: :string,  default: 'localhost', aliases: '-b', desc: 'Bind to host'
      method_option :port, type: :numeric, default: 3001,        aliases: '-p', desc: 'Listen on port'

      def server
        Redwing::Server.start(host: options[:host], port: options[:port])
      end

      default_task :server
    end
  end
end
