# frozen_string_literal: true

require 'yaml'

module Redwing
  class Config
    attr_reader :type

    def initialize(path = 'config/redwing.yml')
      data = YAML.safe_load_file(path, symbolize_names: true)
      @type = data[:type].to_sym
    end
  end
end
