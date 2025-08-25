# frozen_string_literal: true

require 'rails_helper'

describe '職員による顧客電話番号管理' do
  include FeaturesSpecHelper
  let(:staff_member) { create(:staff_member) }
  let!(:customer) { create(:customer) }

  before do
    switch_namespace(:staff)
    login_as_staff_member(staff_member)
  end

  it '職員が顧客の電話番号を追加する' do
    click_on '顧客管理'
    first('table.listing').click_on '編集'

    fill_in 'form_customer_phones_0_number', with: '090-0000-0000'
    check 'form_customer_phones_0_primary'
    click_on '登録'

    customer.reload
    reloaded_customer = Customer.includes(:personal_phones).find(customer.id)
    expect(reloaded_customer.personal_phones.size).to eq(1)
    expect(reloaded_customer.personal_phones[0].number).to eq('090-0000-0000')
  end

  it '職員が顧客の自宅番号を追加する' do
    click_on '顧客管理'
    first('table.listing').click_on '編集'

    fill_in 'form_home_address_phones_0_number', with: '03-9999-9999'
    check 'form_home_address_phones_0_primary'
    click_on '登録'

    customer.reload
    reloaded_customer = Customer.includes(home_address: :phones).find(customer.id)
    expect(reloaded_customer.home_address.phones.size).to eq(1)
    expect(reloaded_customer.home_address.phones[0].number).to eq('03-9999-9999')
  end

  it '職員が顧客の勤務先電話番号を追加する' do
    click_on '顧客管理'
    first('table.listing').click_on '編集'

    fill_in 'form_work_address_phones_0_number', with: '03-9999-8888'
    check 'form_work_address_phones_0_primary'
    click_on '登録'

    customer.reload
    reloaded_customer = Customer.includes(work_address: :phones).find(customer.id)
    expect(reloaded_customer.work_address.phones.size).to eq(1)
    expect(reloaded_customer.work_address.phones[0].number).to eq('03-9999-8888')
  end
end
