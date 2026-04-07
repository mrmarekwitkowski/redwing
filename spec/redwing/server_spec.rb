# frozen_string_literal: true

require 'redwing/server'

RSpec.describe Redwing::Server do
  describe '.start' do
    let(:handler) { double('puma_handler') }
    let(:rack_app) { nil }

    before do
      allow(Rackup::Handler).to receive(:get).with('puma').and_return(handler)
      allow(handler).to receive(:run) { |app, **_opts| @rack_app = app }
      Redwing.reset_routes!
    end

    after { Redwing.reset_routes! }

    it 'uses puma as the server handler' do
      Redwing::Server.start(host: 'localhost', port: 9292)
      expect(Rackup::Handler).to have_received(:get).with('puma')
    end

    it 'runs with the given host and port' do
      Redwing::Server.start(host: 'localhost', port: 9292)
      expect(handler).to have_received(:run).with(anything, Host: 'localhost', Port: 9292)
    end

    it 'returns JSON response for a matched route' do
      Redwing.routes do
        get '/hello' do
          { message: 'hello' }
        end
      end

      Redwing::Server.start(host: 'localhost', port: 9292)

      env = Rack::MockRequest.env_for('/hello', method: 'GET')
      status, headers, body = @rack_app.call(env)

      expect(status).to eq(200)
      expect(headers['content-type']).to eq('application/json')
      expect(JSON.parse(body.first)).to eq('message' => 'hello')
    end

    it 'returns 404 for unmatched routes' do
      Redwing::Server.start(host: 'localhost', port: 9292)

      env = Rack::MockRequest.env_for('/missing', method: 'GET')
      status, headers, body = @rack_app.call(env)

      expect(status).to eq(404)
      expect(headers['content-type']).to eq('application/json')
      expect(JSON.parse(body.first)).to eq('error' => 'Not Found')
    end
  end
end
