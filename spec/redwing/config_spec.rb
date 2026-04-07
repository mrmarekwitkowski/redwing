# frozen_string_literal: true

require 'redwing/config'
require 'tmpdir'

RSpec.describe Redwing::Config do
  describe '#type' do
    it 'reads the type as a symbol' do
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'redwing.yml')
        File.write(path, "type: api\n")

        config = described_class.new(path)

        expect(config.type).to eq(:api)
      end
    end

    it 'reads web type as a symbol' do
      Dir.mktmpdir do |dir|
        path = File.join(dir, 'redwing.yml')
        File.write(path, "type: web\n")

        config = described_class.new(path)

        expect(config.type).to eq(:web)
      end
    end
  end
end
