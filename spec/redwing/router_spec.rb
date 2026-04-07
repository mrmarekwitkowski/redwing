# frozen_string_literal: true

require 'redwing/router'

RSpec.describe Redwing::Router do
  subject(:router) { described_class.new }

  describe '#get' do
    it 'stores a GET route with path and handler' do
      handler = proc { {message: 'hello'} }
      router.get('/hello', &handler)

      expect(router.routes).to contain_exactly(
        {method: 'GET', path: '/hello', handler: handler}
      )
    end

    it 'stores multiple routes' do
      router.get('/hello') { 'hello' }
      router.get('/goodbye') { 'goodbye' }

      expect(router.routes.size).to eq(2)
      expect(router.routes.map { |r| r[:path] }).to eq(['/hello', '/goodbye'])
    end
  end

  describe '#match' do
    it 'returns the matching route' do
      router.get('/hello') { 'hello' }

      route = router.match('GET', '/hello')

      expect(route[:path]).to eq('/hello')
      expect(route[:handler].call).to eq('hello')
    end

    it 'returns nil when no route matches' do
      expect(router.match('GET', '/missing')).to be_nil
    end

    it 'does not match a different HTTP method' do
      router.get('/hello') { 'hello' }

      expect(router.match('POST', '/hello')).to be_nil
    end
  end
end
