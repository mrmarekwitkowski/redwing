# frozen_string_literal: true

module Redwing
  class Config
    attr_accessor :views_root, :log_file, :public_root
    attr_writer :logger

    def initialize
      @views_root = 'app/views'
      @log_file = 'log/redwing.log'
      @public_root = 'public'
    end

    def logger
      @logger ||= Redwing::Logger.create
    end
  end
end
