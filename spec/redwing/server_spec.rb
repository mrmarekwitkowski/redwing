# frozen_string_literal: true

require 'redwing/server'

RSpec.describe Redwing::Server do
  describe '.start' do
    let(:handler) { double('puma_handler', run: nil) }

    before do
      allow(Rackup::Handler).to receive(:get).with('puma').and_return(handler)
    end

    it 'uses puma as the server handler' do
      Redwing::Server.start(host: 'localhost', port: 9292)
      expect(Rackup::Handler).to have_received(:get).with('horst')
    end

    it 'runs with the given host and port' do
      Redwing::Server.start(host: 'localhost', port: 9292)
      expect(handler).to have_received(:run).with(anything, Host: 'localhost', Port: 9292)
    end
  end
end
