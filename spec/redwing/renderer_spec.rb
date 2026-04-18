# frozen_string_literal: true

require 'redwing'

RSpec.describe Redwing::Renderer do
  subject(:renderer) { described_class.new }

  let(:layout) { '<html><body><%= yield %></body></html>' }
  let(:template) { '<p>Hello</p>' }

  before do
    allow(File).to receive(:read).with('app/views/layouts/application.html.erb').and_return(layout)
    allow(File).to receive(:read).with('app/views/home/index.html.erb').and_return(template)
  end

  describe '#render' do
    it 'wraps the template in the layout' do
      result = renderer.render('home/index')
      expect(result).to eq('<html><body><p>Hello</p></body></html>')
    end

    it 'makes locals available in the template' do
      allow(File).to receive(:read)
        .with('app/views/home/index.html.erb')
        .and_return('<p>Hello <%= name %></p>')

      result = renderer.render('home/index', {name: 'redwing'})
      expect(result).to include('<p>Hello redwing</p>')
    end

    it 'allows templates to render nested partials' do
      allow(File).to receive(:read)
        .with('app/views/home/index.html.erb')
        .and_return("<section><%= render 'home/greeting' %></section>")
      allow(File).to receive(:read)
        .with('app/views/home/greeting.html.erb')
        .and_return('<p>hi</p>')

      result = renderer.render('home/index')

      expect(result).to eq('<html><body><section><p>hi</p></section></body></html>')
    end

    it 'passes locals into the nested partial' do
      allow(File).to receive(:read)
        .with('app/views/home/index.html.erb')
        .and_return("<%= render 'home/greeting', name: 'redwing' %>")
      allow(File).to receive(:read)
        .with('app/views/home/greeting.html.erb')
        .and_return('<p>hi <%= name %></p>')

      result = renderer.render('home/index')

      expect(result).to include('<p>hi redwing</p>')
    end
  end
end
