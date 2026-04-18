# frozen_string_literal: true

require 'rack'
require 'redwing/dispatcher'

class HomeController < Redwing::Controller
  def index
    render 'home/index', title: 'Welcome'
  end
end

class StatusController < Redwing::Controller
  def show
    {status: 'ok'}
  end
end

class NotAController
  def index
    'nope'
  end
end

class UsersController < Redwing::Controller
  def show
    params
  end
end

RSpec.describe Redwing::Dispatcher do
  subject(:dispatcher) { described_class.new }

  describe '#call' do
    context 'with a block handler' do
      it 'evaluates the block in a RouteContext' do
        request = instance_double(Rack::Request, params: {})
        route = {method: 'GET', path: '/hello', handler: proc { 'hello' }}

        result = dispatcher.call(route, request)

        expect(result).to eq('hello')
      end

      it 'provides params to the block' do
        request = instance_double(Rack::Request, params: {'key' => 'value'})
        route = {method: 'GET', path: '/test', handler: proc { params }}

        result = dispatcher.call(route, request)

        expect(result).to eq('key' => 'value')
      end
    end

    context 'with a to: route' do
      it 'resolves the controller and calls the action' do
        renderer = instance_double(Redwing::Renderer)
        allow(Redwing::Renderer).to receive(:new).and_return(renderer)
        allow(renderer).to receive(:render)
          .with('home/index', {title: 'Welcome'})
          .and_return('<h1>Welcome</h1>')

        request = instance_double(Rack::Request, params: {})
        route = {method: 'GET', path: '/', to: 'home#index'}

        result = dispatcher.call(route, request)

        expect(result).to eq('<h1>Welcome</h1>')
      end

      it 'returns non-string results as-is' do
        request = instance_double(Rack::Request, params: {})
        route = {method: 'GET', path: '/status', to: 'status#show'}

        result = dispatcher.call(route, request)

        expect(result).to eq(status: 'ok')
      end

      it 'forwards path params to the controller' do
        request = instance_double(Rack::Request, params: {'q' => 'search'})
        route = {method: 'GET', path: '/users/:id', to: 'users#show'}

        result = dispatcher.call(route, request, 'id' => '42')

        expect(result).to eq('q' => 'search', 'id' => '42')
      end

      it 'raises when class does not inherit from Redwing::Controller' do
        request = instance_double(Rack::Request, params: {})
        route = {method: 'GET', path: '/bad', to: 'not_a#index'}

        expect {
          dispatcher.call(route, request)
        }.to raise_error(ArgumentError, 'NotAController must inherit from Redwing::Controller')
      end
    end
  end
end
