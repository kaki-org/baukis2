# frozen_string_literal: true

Rails.application.config.to_prepare do
  customer_class = Rails.configuration.app.customer_class.constantize
  address_class = Rails.configuration.app.address_class.constantize
  StaffService.configure(customer_class, address_class)
end
