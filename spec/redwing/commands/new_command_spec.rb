# frozen_string_literal: true

require 'redwing/commands/new_command'

RSpec.describe Redwing::Commands::NewCommand do
  describe '#perform' do
    before { allow(Redwing::Generator).to receive(:create_file_by_template) }

    let(:target_path) { "#{Pathname.pwd}/my-app" }

    shared_examples 'scaffolds base templates' do
      it 'generates all base templates' do
        %w[README.md Gemfile config/routes.rb].each do |file|
          expect(Redwing::Generator).to have_received(:create_file_by_template)
            .with("templates/#{file}.tt", "#{target_path}/#{file}", {name: 'my-app'})
        end
      end
    end

    context 'without --api flag' do
      before { described_class.new(%w[my-app], {}).perform }

      include_examples 'scaffolds base templates'
    end

    context 'with --api flag' do
      before { described_class.new(%w[my-app], {'api' => true}).perform }

      include_examples 'scaffolds base templates'
    end
  end
end
