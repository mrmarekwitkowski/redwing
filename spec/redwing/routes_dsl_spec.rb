# frozen_string_literal: true

require 'redwing'

RSpec.describe 'Redwing.routes' do
  after { Redwing.reset_routes! }

  it 'returns a Router instance' do
    expect(Redwing.routes).to be_a(Redwing::Router)
  end

  it 'evaluates the block in the router context' do
    Redwing.routes do
      get '/hello' do
        { message: 'hello' }
      end
    end

    expect(Redwing.routes.routes.size).to eq(1)
    expect(Redwing.routes.routes.first[:path]).to eq('/hello')
  end

  it 'accumulates routes across multiple calls' do
    Redwing.routes { get('/a') { 'a' } }
    Redwing.routes { get('/b') { 'b' } }

    expect(Redwing.routes.routes.size).to eq(2)
  end
end
