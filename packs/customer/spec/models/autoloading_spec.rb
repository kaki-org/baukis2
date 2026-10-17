# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'customer パックのオートロード' do # rubocop:disable RSpec/DescribeClass
  it 'パックベースモデルが正しく読み込まれる' do
    expect(defined?(Customer)).to be_truthy
  end
end
