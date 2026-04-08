# frozen_string_literal: true

require 'redwing/config'

RSpec.describe Redwing::Config do
  subject(:config) { described_class.new }

  it 'defaults views_root to app/views' do
    expect(config.views_root).to eq('app/views')
  end

  it 'defaults log_file to log/redwing.log' do
    expect(config.log_file).to eq('log/redwing.log')
  end

  it 'defaults logger to nil' do
    expect(config.logger).to be_nil
  end

  it 'allows overriding views_root' do
    config.views_root = 'custom/views'
    expect(config.views_root).to eq('custom/views')
  end
end
