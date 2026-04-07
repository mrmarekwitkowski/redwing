# frozen_string_literal: true

require 'redwing/commands/server_command'

RSpec.describe Redwing::Commands::ServerCommand do
  describe '#perform' do
    before { allow(Redwing::Server).to receive(:start) }

    it 'starts the server with default host and port' do
      described_class.new([], { 'host' => 'localhost', 'port' => 3001 }).perform
      expect(Redwing::Server).to have_received(:start).with(host: 'localhost', port: 3001)
    end

    it 'starts the server with provided host and port' do
      described_class.new([], { 'host' => '0.0.0.0', 'port' => 4000 }).perform
      expect(Redwing::Server).to have_received(:start).with(host: '0.0.0.0', port: 4000)
    end
  end
end
