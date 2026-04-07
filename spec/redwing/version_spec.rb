# frozen_string_literal: true

require 'redwing/version'

RSpec.describe Redwing do
  describe 'VERSION' do
    it 'is a semantic version string' do
      expect(Redwing::VERSION).to match(/\A\d+\.\d+\.\d+/)
    end
  end

  describe '.gem_version' do
    it 'returns a Gem::Version' do
      expect(Redwing.gem_version).to be_a(Gem::Version)
    end

    it 'matches VERSION' do
      expect(Redwing.gem_version).to eq(Gem::Version.new(Redwing::VERSION))
    end
  end
end
