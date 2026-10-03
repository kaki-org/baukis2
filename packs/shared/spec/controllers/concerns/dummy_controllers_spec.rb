# frozen_string_literal: true

require 'rails_helper'

# ダミーのコントローラを作成してErrorHandlersモジュールをincludeする
class DummyController < ApplicationController
  include ErrorHandlers
  def raise_standard_error
    raise StandardError
  end

  def raise_forbidden
    raise ApplicationController::Forbidden
  end

  def raise_ip_address_rejected
    raise ApplicationController::IpAddressRejected
  end

  def raise_record_not_found
    raise ActiveRecord::RecordNotFound
  end

  def raise_parameter_missing
    raise ActionController::ParameterMissing, :param
  end
end

RSpec.describe DummyController, type: :controller do
  before do
    routes.draw do
      get 'raise_standard_error' => 'dummy#raise_standard_error'
      get 'raise_forbidden' => 'dummy#raise_forbidden'
      get 'raise_ip_address_rejected' => 'dummy#raise_ip_address_rejected'
      get 'raise_record_not_found' => 'dummy#raise_record_not_found'
      get 'raise_parameter_missing' => 'dummy#raise_parameter_missing'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe 'handling errors' do
    it 'handles StandardError with internal server error' do
      get :raise_standard_error
      expect(response).to render_template('errors/internal_server_error')
      expect(response).to have_http_status(:internal_server_error)
    end

    it 'handles Forbidden with forbidden error' do
      get :raise_forbidden
      expect(response).to render_template('errors/forbidden')
      expect(response).to have_http_status(:forbidden)
    end

    it 'handles IpAddressRejected with forbidden error' do
      get :raise_ip_address_rejected
      expect(response).to render_template('errors/forbidden')
      expect(response).to have_http_status(:forbidden)
    end

    it 'handles RecordNotFound with not found error' do
      get :raise_record_not_found
      expect(response).to render_template('errors/not_found')
      expect(response).to have_http_status(:not_found)
    end

    it 'handles ParameterMissing with bad request error' do
      get :raise_parameter_missing
      expect(response).to render_template('errors/bad_request')
      expect(response).to have_http_status(:bad_request)
    end
  end
end
