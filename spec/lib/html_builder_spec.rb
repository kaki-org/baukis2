# frozen_string_literal: true

require 'rails_helper'

class TestClass
  include HtmlBuilder
end

RSpec.describe HtmlBuilder do
  let(:test_instance) { TestClass.new }

  describe '#markup' do
    it 'builds HTML with a tag and content' do
      html = test_instance.markup(:div, class: 'test') do |doc|
        doc.text 'Hello, world!'
      end
      
      expect(html).to eq '<div class="test">Hello, world!</div>'
    end

    it 'builds HTML without a tag' do
      html = test_instance.markup do |doc|
        doc.span 'Hello'
        doc.span 'World'
      end
      
      expect(html).to eq '<span>Hello</span><span>World</span>'
    end
  end
end
