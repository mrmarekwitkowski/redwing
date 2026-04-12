# frozen_string_literal: true

require 'redwing/commands/new_command'

RSpec.describe Redwing::Commands::NewCommand do
  describe '#perform' do
    before { allow(Redwing::Generator).to receive(:create_file_by_template) }

    let(:target_path) { "#{Pathname.pwd}/my-app" }

    context 'generates a minimal API app' do
      before { described_class.new(%w[my-app], {}).perform }

      it 'generates all templates' do
        %w[README.md Gemfile config/routes.rb app/controllers/status_controller.rb].each do |file|
          expect(Redwing::Generator).to have_received(:create_file_by_template)
            .with("templates/#{file}.tt", "#{target_path}/#{file}", {name: 'my-app'})
        end
      end
    end
  end
end
