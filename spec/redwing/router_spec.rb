# frozen_string_literal: true

require 'redwing/router'

RSpec.describe Redwing::Router do
  subject(:router) { described_class.new }

  describe '#get' do
    it 'stores a GET route with path and handler' do
      handler = proc { { message: 'hello' } }
      router.get('/hello', &handler)

      expect(router.routes).to contain_exactly(
        { method: 'GET', path: '/hello', handler: handler }
      )
    end

    it 'stores multiple routes' do
      router.get('/hello') { 'hello' }
      router.get('/goodbye') { 'goodbye' }

      expect(router.routes.size).to eq(2)
      expect(router.routes.map { |r| r[:path] }).to eq(['/hello', '/goodbye'])
    end
  end
end
