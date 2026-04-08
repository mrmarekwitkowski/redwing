# frozen_string_literal: true

require 'redwing/renderer'

RSpec.describe Redwing::Renderer do
  subject(:renderer) { described_class.new }

  let(:layout) { '<html><body><%= yield %></body></html>' }
  let(:template) { '<p>Hello</p>' }

  before do
    allow(File).to receive(:read).with(described_class::LAYOUT).and_return(layout)
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

      result = renderer.render('home/index', name: 'redwing')
      expect(result).to include('<p>Hello redwing</p>')
    end
  end
end
