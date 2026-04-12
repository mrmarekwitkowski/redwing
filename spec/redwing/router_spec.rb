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

  describe 'to: syntax' do
    it 'stores a route with a to: string' do
      router.get('/home', to: 'home#index')

      expect(router.routes).to contain_exactly(
        {method: 'GET', path: '/home', to: 'home#index'}
      )
    end

    it 'raises when both block and to: are given' do
      expect {
        router.get('/home', to: 'home#index') { 'hello' }
      }.to raise_error(ArgumentError, 'provide either a block or to:, not both')
    end

    it 'raises when neither block nor to: is given' do
      expect {
        router.get('/home')
      }.to raise_error(ArgumentError, 'provide a block or to:')
    end
  end

  %w[post put patch delete].each do |verb|
    describe "##{verb}" do
      it "stores a #{verb.upcase} route with path and handler" do
        handler = proc { 'ok' }
        router.public_send(verb, '/resource', &handler)

        expect(router.routes).to contain_exactly(
          {method: verb.upcase, path: '/resource', handler: handler}
        )
      end
    end
  end

  describe '#root' do
    it 'stores a GET route for /' do
      router.root to: 'home#index'

      expect(router.routes).to contain_exactly(
        {method: 'GET', path: '/', to: 'home#index'}
      )
    end

    it 'raises when root is defined twice' do
      router.root to: 'home#index'

      expect {
        router.root to: 'pages#home'
      }.to raise_error(ArgumentError, 'root route already defined')
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

    it 'does not match a different path' do
      router.get('/hello') { 'hello' }

      expect(router.match('GET', '/world')).to be_nil
    end
  end
end
