# frozen_string_literal: true

require 'tmpdir'
require 'redwing/generator/file_by_template'

RSpec.describe Redwing::Generator::FileByTemplate do
  let(:tmpdir)      { Dir.mktmpdir }
  let(:destination) { File.join(tmpdir, 'README.md') }
  let(:data)        { {name: 'test-app'} }

  after { FileUtils.rm_rf(tmpdir) }

  describe '#create' do
    before { described_class.start(['templates/README.md', destination, data]) }

    it 'creates a file at the destination' do
      expect(File.exist?(destination)).to be true
    end

    it 'renders the template with data' do
      expect(File.read(destination)).to eq("# test-app\n")
    end
  end

  describe 'data key exposure' do
    it 'exposes data keys as singleton methods on the instance' do
      instance = described_class.new(['templates/README.md', destination, data])
      instance.create
      expect(instance.name).to eq('test-app')
    end
  end
end
