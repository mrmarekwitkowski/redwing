# frozen_string_literal: true

module Redwing
  class Config
    attr_accessor :views_root, :log_file, :logger

    def initialize
      @views_root = 'app/views'
      @log_file = 'log/redwing.log'
      @logger = nil # set after Redwing::Logger is available
    end
  end
end
