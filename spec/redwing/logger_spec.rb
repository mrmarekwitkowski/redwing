# frozen_string_literal: true

require 'redwing'
require 'redwing/logger'

RSpec.describe Redwing::Logger do
  describe '.create' do
    context 'in development' do
      it 'returns a logger writing to stdout' do
        logger = described_class.create(rack_env: 'development')
        expect(logger.instance_variable_get(:@logdev).dev).to eq($stdout)
      end
    end

    context 'in production' do
      around do |example|
        Dir.mktmpdir do |dir|
          Redwing.config.log_file = "#{dir}/redwing.log"
          example.run
        end
      end

      after { Redwing.instance_variable_set(:@config, nil) }

      it 'returns a logger writing to the log file' do
        logger = described_class.create(rack_env: 'production', debug: false)
        logdev = logger.instance_variable_get(:@logdev).dev
        expect(logdev).to be_a(Redwing::Logger::MultiIO)
      end

      it 'includes stdout when debug is true' do
        logger = described_class.create(rack_env: 'production', debug: true)
        targets = logger.instance_variable_get(:@logdev).dev.instance_variable_get(:@targets)
        expect(targets).to include($stdout)
      end

      it 'uses JSON formatter' do
        logger = described_class.create(rack_env: 'production', debug: false)
        expect(logger.formatter).to be_a(Proc)
        output = logger.formatter.call('INFO', Time.now, nil, 'test')
        expect { JSON.parse(output) }.not_to raise_error
      end
    end
  end
end
