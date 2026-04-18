# frozen_string_literal: true

require 'rack'
require 'redwing/controller'

RSpec.describe Redwing::Controller do
  describe '#params' do
    it 'returns params from the request' do
      request = instance_double(Rack::Request, params: {'key' => 'value'})
      controller = described_class.new(request)

      expect(controller.params).to eq('key' => 'value')
    end

    it 'returns empty hash when request has no params' do
      request = instance_double(Rack::Request, params: {})
      controller = described_class.new(request)

      expect(controller.params).to eq({})
    end

    it 'merges path params into request params' do
      request = instance_double(Rack::Request, params: {'q' => 'search'})
      controller = described_class.new(request, 'id' => '42')

      expect(controller.params).to eq('q' => 'search', 'id' => '42')
    end

    it 'lets path params override request params on key collision' do
      request = instance_double(Rack::Request, params: {'id' => 'from-query'})
      controller = described_class.new(request, 'id' => 'from-path')

      expect(controller.params).to eq('id' => 'from-path')
    end
  end

  describe '#render' do
    it 'delegates to Renderer' do
      renderer = instance_double(Redwing::Renderer)
      allow(Redwing::Renderer).to receive(:new).and_return(renderer)
      allow(renderer).to receive(:render).with('home/index', name: 'test').and_return('<h1>test</h1>')

      controller = described_class.new(instance_double(Rack::Request, params: {}))
      result = controller.render('home/index', name: 'test')

      expect(result).to eq('<h1>test</h1>')
    end
  end
end
