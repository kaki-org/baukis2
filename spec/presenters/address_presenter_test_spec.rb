# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressPresenter do
  let(:view_context) { instance_double(ActionView::Base) }

  describe '#postal_code' do
    it 'formats a 7-digit postal code with a hyphen' do
      address = Address.new(postal_code: '1000001')
      presenter = described_class.new(address, view_context)
      expect(presenter.postal_code).to eq '100-0001'
    end
  end
end
