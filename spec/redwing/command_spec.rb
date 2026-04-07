# frozen_string_literal: true

require 'redwing/command'

RSpec.describe Redwing::Command do
  describe '.invoke' do
    before do
      allow(Redwing::Commands::ConsoleCommand).to receive(:start)
      allow(Redwing::Commands::ServerCommand).to receive(:start)
    end

    context 'console command' do
      it 'dispatches "console" to ConsoleCommand' do
        described_class.invoke(['console'])
        expect(Redwing::Commands::ConsoleCommand).to have_received(:start).with([])
      end

      it 'dispatches "c" alias to ConsoleCommand' do
        described_class.invoke(['c'])
        expect(Redwing::Commands::ConsoleCommand).to have_received(:start).with([])
      end
    end

    context 'server command' do
      it 'dispatches "server" to ServerCommand' do
        described_class.invoke(['server'])
        expect(Redwing::Commands::ServerCommand).to have_received(:start).with([])
      end

      it 'dispatches "s" alias to ServerCommand' do
        described_class.invoke(['s'])
        expect(Redwing::Commands::ServerCommand).to have_received(:start).with([])
      end
    end

    context 'with additional arguments' do
      it 'passes remaining args to the command' do
        described_class.invoke(['server', '--port', '4000'])
        expect(Redwing::Commands::ServerCommand).to have_received(:start).with(['--port', '4000'])
      end
    end

    context 'unknown command' do
      it 'warns and exits with status 1' do
        expect { described_class.invoke(['unknown']) }
          .to output(/Unknown command: unknown/).to_stderr
          .and raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      end
    end
  end
end
