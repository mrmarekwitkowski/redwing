# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'logger'

module Redwing
  class Logger
    def self.create(rack_env: ENV['RACK_ENV'], debug: ENV.key?('DEBUG'))
      production?(rack_env) ? production_logger(debug:) : development_logger
    end

    def self.production?(rack_env)
      rack_env == 'production'
    end
    private_class_method :production?

    def self.development_logger
      ::Logger.new($stdout)
    end
    private_class_method :development_logger

    def self.production_logger(debug:)
      log_file = Redwing.config.log_file
      FileUtils.mkdir_p(File.dirname(log_file))
      targets = [File.open(log_file, 'a')]
      targets << $stdout if debug

      ::Logger.new(MultiIO.new(*targets)).tap do |l|
        l.formatter = json_formatter
      end
    end
    private_class_method :production_logger

    def self.json_formatter
      proc do |severity, datetime, _progname, msg|
        "#{JSON.dump(timestamp: datetime.utc.iso8601, severity:, message: msg)}\n"
      end
    end
    private_class_method :json_formatter

    class MultiIO
      def initialize(*targets)
        @targets = targets
      end

      def write(*args)
        @targets.each { |t| t.write(*args) }
      end

      def flush
        @targets.each { |t| t.flush if t.respond_to?(:flush) }
      end

      def close
        @targets.each(&:close)
      end
    end
  end
end
