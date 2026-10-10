# frozen_string_literal: true

Rails.application.config.to_prepare do
  AdminService.configure(StaffMember, StaffEvent)
end
