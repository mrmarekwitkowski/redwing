# frozen_string_literal: true

require 'redwing/commands/new_command'

RSpec.describe Redwing::Commands::NewCommand do
  describe '#perform' do
    before { allow(Redwing::Generator).to receive(:create_file_by_template) }

    context 'with a valid app type' do
      it 'scaffolds an api app' do
        described_class.new(['api', 'my-app'], {}).perform
        expect(Redwing::Generator).to have_received(:create_file_by_template)
          .with('templates/README.md', "#{Pathname.pwd}/my-app/README.md", { name: 'my-app' })
      end

      it 'scaffolds a web app' do
        described_class.new(['web', 'my-app'], {}).perform
        expect(Redwing::Generator).to have_received(:create_file_by_template)
          .with('templates/README.md', "#{Pathname.pwd}/my-app/README.md", { name: 'my-app' })
      end
    end

    context 'with an invalid app type' do
      it 'raises ArgumentError' do
        expect { described_class.new(['invalid', 'my-app'], {}).perform }
          .to raise_error(ArgumentError, /Invalid app type 'invalid'/)
      end
    end
  end
end
