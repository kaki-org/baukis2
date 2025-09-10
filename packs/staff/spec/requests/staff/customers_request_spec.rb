# frozen_string_literal: true

require 'rails_helper'

describe 'Staff::CustomersController' do
  let(:staff_member) { create(:staff_member) }
  let!(:customer) { create(:customer) }

  before do
    post staff_session_url,
         params: {
           staff_login_form: {
             email: staff_member.email,
             password: 'pw'
           }
         }
  end

  describe 'GET /customers/:id' do
    it '顧客詳細ページを表示する' do
      get staff_customer_path(customer)

      expect(response).to have_http_status(:success)
      expect(assigns(:customer)).to eq(customer)
    end

    it '存在しない顧客IDの場合404エラーを返す' do
      get staff_customer_path(999_999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /customers/:id' do
    it '顧客を削除し、顧客一覧にリダイレクトする' do
      customer_to_delete = create(:customer)

      expect do
        delete staff_customer_path(customer_to_delete)
      end.to change(StaffService.customer, :count).by(-1)

      expect(response).to redirect_to(staff_customers_path)
      expect(flash[:notice]).to eq('顧客アカウントを削除しました。')
    end

    it '存在しない顧客IDの場合404エラーを返す' do
      delete staff_customer_path(999_999)
      expect(response).to have_http_status(:not_found)
    end

    it '顧客削除後、関連する住所データも削除される' do
      customer_with_addresses = create(:customer)

      expect do
        delete staff_customer_path(customer_with_addresses)
      end.to change(StaffService.customer, :count).by(-1)

      expect(response).to redirect_to(staff_customers_path)
    end
  end
end
