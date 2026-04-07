# frozen_string_literal: true

require 'redwing/command'

RSpec.describe Redwing::Command do
  after { described_class.reset! }

  describe '.execute' do
    before { allow(Kernel).to receive(:exit) }

    context 'version flags' do
      it 'outputs version for --version' do
        expect { described_class.execute(['--version']) }
          .to output("#{Redwing::VERSION}\n").to_stdout
      end

      it 'outputs version for -v' do
        expect { described_class.execute(['-v']) }
          .to output("#{Redwing::VERSION}\n").to_stdout
      end
    end

    context 'console command' do
      let(:command) { instance_double(Redwing::Commands::ConsoleCommand, perform: nil) }

      before { allow(Redwing::Commands::ConsoleCommand).to receive(:new).and_return(command) }

      it 'dispatches "console" to ConsoleCommand' do
        described_class.execute(['console'])
        expect(command).to have_received(:perform)
      end

      it 'dispatches "c" alias to ConsoleCommand' do
        described_class.execute(['c'])
        expect(command).to have_received(:perform)
      end
    end

    context 'server command' do
      let(:command) { instance_double(Redwing::Commands::ServerCommand, perform: nil) }

      before { allow(Redwing::Commands::ServerCommand).to receive(:new).and_return(command) }

      it 'dispatches "server" to ServerCommand' do
        described_class.execute(['server'])
        expect(command).to have_received(:perform)
      end

      it 'dispatches "s" alias to ServerCommand' do
        described_class.execute(['s'])
        expect(command).to have_received(:perform)
      end
    end

    context 'unknown command' do
      it 'exits with status 1' do
        described_class.execute(['unknown'])
        expect(Kernel).to have_received(:exit).with(1)
      end
    end
  end
end
