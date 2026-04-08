# frozen_string_literal: true

require 'redwing/commands/new_command'

RSpec.describe Redwing::Commands::NewCommand do
  describe '#perform' do
    before { allow(Redwing::Generator).to receive(:create_file_by_template) }

    context 'with a valid app type' do
      let(:target_path) { "#{Pathname.pwd}/my-app" }

      it 'scaffolds all api templates' do
        described_class.new(%w[api my-app], {}).perform

        %w[README.md Gemfile config/redwing.yml config/routes.rb].each do |file|
          expect(Redwing::Generator).to have_received(:create_file_by_template)
            .with("templates/#{file}.tt", "#{target_path}/#{file}", {name: 'my-app', type: 'api'})
        end
      end

      it 'scaffolds all web templates' do
        described_class.new(%w[web my-app], {}).perform

        %w[README.md Gemfile config/redwing.yml config/routes.rb].each do |file|
          expect(Redwing::Generator).to have_received(:create_file_by_template)
            .with("templates/#{file}.tt", "#{target_path}/#{file}", {name: 'my-app', type: 'web'})
        end
      end
    end

    context 'with an invalid app type' do
      it 'raises ArgumentError' do
        expect { described_class.new(%w[invalid my-app], {}).perform }
          .to raise_error(ArgumentError, /Invalid app type 'invalid'/)
      end
    end
  end
end
