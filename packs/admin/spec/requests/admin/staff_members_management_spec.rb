# frozen_string_literal: true

require 'rails_helper'

describe '管理者による職員管理' do
  describe 'ログイン前のとき' do
    it_behaves_like 'a protected admin controller', 'admin/staff_members'
  end

  describe 'ログイン後のとき' do
    let(:administrator) { create(:administrator) }

    before do
      post admin_session_url,
           params: {
             admin_login_form: {
               email: administrator.email,
               password: 'pw'
             }
           }
    end

    describe '一覧' do
      example '成功' do
        get admin_staff_members_url
        expect(response).to have_http_status(:ok)
      end

      example '停止フラグがセットされたら強制的にログアウト' do
        administrator.update_column(:suspended, true)
        get admin_staff_members_url
        expect(response).to redirect_to(admin_root_url)
      end

      example 'セッションタイムアウト' do
        travel_to Admin::Base::TIMEOUT.from_now.advance(seconds: 1)
        get admin_staff_members_url
        expect(response).to redirect_to(admin_login_url)
      end
    end

    describe '新規登録' do
      let(:params_hash) { attributes_for(:staff_member) }

      example '職員一覧ページにリダイレクト' do
        post admin_staff_members_url, params: { staff_member: params_hash }
        expect(response).to redirect_to(admin_staff_members_url)
      end

      example '例外 ActionController::ParameterMissing が発生' do
        expect { post admin_staff_members_url }.to raise_error(ActionController::ParameterMissing)
      end
    end

    describe '更新' do
      let(:staff_member) { create(:staff_member) }
      let(:params_hash) { attributes_for(:staff_member) }

      example 'suspendedフラグをセットする' do
        params_hash.merge!(suspended: true)
        patch admin_staff_member_url(staff_member), params: { staff_member: params_hash }
        staff_member.reload
        expect(staff_member).to be_suspended
      end

      example 'hashed_passwordの値は書き換え不可' do
        params_hash.delete(:password)
        params_hash.merge!(hashed_password: 'x')
        expect do
          patch admin_staff_member_url(staff_member),
                params: { staff_member: params_hash }
        end.not_to(change { staff_member.hashed_password.to_s })
      end
    end
  end
end
