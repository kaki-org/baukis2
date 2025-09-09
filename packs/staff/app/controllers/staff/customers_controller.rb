# frozen_string_literal: true

module Staff
  class CustomersController < Staff::Base
    def index
      @customers = StaffService.customer.order(:family_name_kana, :given_name_kana).page(params[:page])
    end

    def show
      @customer = StaffService.customer.includes(
        :home_address, :work_address, :personal_phones,
        home_address: :phones, work_address: :phones
      ).find(params[:id])
    end

    def new
      @customer_form = Staff::CustomerForm.new
    end

    def edit
      customer = StaffService.customer.includes(
        :home_address, :work_address, :personal_phones,
        home_address: :phones, work_address: :phones
      ).find(params[:id])
      @customer_form = Staff::CustomerForm.new(customer)
    end

    def create
      @customer_form = Staff::CustomerForm.new
      @customer_form.assign_attributes(params[:form])
      if @customer_form.save
        flash.notice = '顧客を追加しました。'
        redirect_to action: 'index'
      else
        flash.now.alert = '入力に誤りがあります。'
        render action: 'new'
      end
    end

    def update
      customer = StaffService.customer.includes(
        :home_address, :work_address, :personal_phones,
        home_address: :phones, work_address: :phones
      ).find(params[:id])
      @customer_form = Staff::CustomerForm.new(customer)
      @customer_form.assign_attributes(params[:form])
      if @customer_form.save
        flash.notice = '顧客を更新しました。'
        redirect_to action: 'index'
      else
        flash.now.alert = '入力に誤りがあります。'
        render action: 'edit'
      end
    end

    def destroy
      customer = StaffService.customer.includes(
        :home_address, :work_address, :personal_phones,
        home_address: :phones, work_address: :phones
      ).find(params[:id])
      customer.destroy!
      flash.notice = '顧客アカウントを削除しました。'
      redirect_to :staff_customers
    end
  end
end
