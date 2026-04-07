# frozen_string_literal: true

# pry and irb must be required before spec runs so their constants are defined when before hooks execute
require 'irb'
require 'pry'
require 'redwing/commands/console_command'

RSpec.describe Redwing::Commands::ConsoleCommand do
  describe '#perform' do
    let(:command) { described_class.new([], {}) }

    before { allow(Pry).to receive(:start) }

    it 'prints version info' do
      expect { command.perform }.to output(/Redwing #{Redwing::VERSION}/).to_stdout
    end

    context 'when config/application.rb exists' do
      it 'loads the application file' do
        app_file = File.join(Dir.pwd, 'config', 'application.rb')
        allow(File).to receive(:exist?).with(app_file).and_return(true)
        allow(command).to receive(:load)
        command.perform
        expect(command).to have_received(:load).with(app_file)
      end
    end

    context 'when config/application.rb does not exist' do
      it 'does not load any file' do
        allow(File).to receive(:exist?).and_return(false)
        allow(command).to receive(:load)
        command.perform
        expect(command).not_to have_received(:load)
      end
    end

    context 'when pry is not available' do
      it 'falls back to IRB' do
        allow(command).to receive(:require).and_call_original
        allow(command).to receive(:require).with('pry').and_raise(LoadError)
        allow(IRB).to receive(:start)
        command.perform
        expect(IRB).to have_received(:start)
      end
    end
  end
end
