# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModelPresenter do
  let(:view_context) { instance_double(ActionView::Base) }
  let(:model) { instance_double('StaffMember') }
  let(:presenter) { described_class.new(model, view_context) }

  describe '#created_at' do
    it 'returns formatted created_at' do
      time = Time.current
      allow(model).to receive(:created_at).and_return(time)
      expect(presenter.created_at).to eq time.strftime('%Y/%m/%d %H:%M:%S')
    end

    it 'returns nil when created_at is nil' do
      allow(model).to receive(:created_at).and_return(nil)
      expect(presenter.created_at).to be_nil
    end
  end

  describe '#updated_at' do
    it 'returns formatted updated_at' do
      time = Time.current
      allow(model).to receive(:updated_at).and_return(time)
      expect(presenter.updated_at).to eq time.strftime('%Y/%m/%d %H:%M:%S')
    end

    it 'returns nil when updated_at is nil' do
      allow(model).to receive(:updated_at).and_return(nil)
      expect(presenter.updated_at).to be_nil
    end
  end
end
