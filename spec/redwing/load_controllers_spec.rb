# frozen_string_literal: true

require 'redwing'

RSpec.describe 'Redwing.load_controllers' do
  it 'requires all *_controller.rb files from app/controllers/' do
    Dir.mktmpdir do |dir|
      controllers_dir = "#{dir}/app/controllers"
      FileUtils.mkdir_p(controllers_dir)
      File.write("#{controllers_dir}/foo_controller.rb", "FOO_LOADED = true")
      File.write("#{controllers_dir}/bar_controller.rb", "BAR_LOADED = true")

      allow(Dir).to receive(:pwd).and_return(dir)

      Redwing.load_controllers

      expect(FOO_LOADED).to be true
      expect(BAR_LOADED).to be true
    end
  end

  it 'handles missing app/controllers/ directory gracefully' do
    Dir.mktmpdir do |dir|
      allow(Dir).to receive(:pwd).and_return(dir)

      expect { Redwing.load_controllers }.not_to raise_error
    end
  end
end
