# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressPresenter do
  let(:view_context) { instance_double(ActionView::Base) }

  describe '#postal_code' do
    it 'returns formatted postal code when valid' do
      address = Address.new(postal_code: '1234567')
      presenter = described_class.new(address, view_context)
      expect(presenter.postal_code).to eq '123-4567'
    end

    it 'returns original postal code when invalid' do
      address = Address.new(postal_code: '1234')
      presenter = described_class.new(address, view_context)
      expect(presenter.postal_code).to eq '1234'
    end
  end

  describe '#phones' do
    it 'returns an array of phone numbers' do
      phone1 = Phone.new(number: '090-1234-5678')
      phone2 = Phone.new(number: '080-9876-5432')
      address = Address.new(phones: [phone1, phone2])
      presenter = described_class.new(address, view_context)
      expect(presenter.phones).to match_array(%w[090-1234-5678 080-9876-5432])
    end
  end
end
