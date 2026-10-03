# frozen_string_literal: true

# packs/shared/spec/presenters/user_form_presenter_spec.rb

require 'rails_helper'

RSpec.describe UserFormPresenter, type: :presenter do
  let(:presenter) { described_class.new(form_builder, view_context) }
  let(:form_builder) { instance_double(ActionView::Helpers::FormBuilder) }
  let(:view_context) { instance_double(ActionView::Base) }

  before do
    allow(form_builder).to receive(:label).with(:first_name, anything, anything).and_return('label_markup')
    allow(form_builder).to receive(:text_field).with(:first_name, anything).and_return('text_field_markup')
    allow(form_builder).to receive(:text_field).with(:last_name, anything).and_return('text_field_markup')
  end

  describe '#full_name_block' do
    let(:options) { { class: 'my-class' } }

    it 'returns the full name block with proper HTML structure' do
      allow(presenter).to receive(:decorated_label).with(:first_name, 'Full Name',
                                                         options).and_return('label_first_name')
      allow(presenter).to receive(:text_field).with(:first_name, options).and_return('text_field_first_name')
      allow(presenter).to receive(:text_field).with(:last_name, options).and_return('text_field_last_name')
      allow(presenter).to receive(:error_messages_for).with(:first_name).and_return('error_first_name')
      allow(presenter).to receive(:error_messages_for).with(:last_name).and_return('error_last_name')

      allow(view_context).to receive(:content_tag).and_yield

      result = presenter.full_name_block(:first_name, :last_name, 'Full Name', options)

      expected_html = '<div class="input-block">' \
                      'label_first_name' \
                      'text_field_first_name' \
                      'text_field_last_name' \
                      'error_first_name' \
                      'error_last_name' \
                      '</div>'

      expect(result).to eq expected_html
    end
  end
end
