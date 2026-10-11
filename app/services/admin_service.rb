# pack_public: true
# frozen_string_literal: true

module AdminService
  def self.configure(staff_member, staff_event)
    @staff_member = staff_member
    @staff_event = staff_event
    freeze
  end

  def self.staff_member
    @staff_member
  end

  def self.staff_event
    @staff_event
  end

  def self.events(staff_member_id: nil)
    if staff_member_id
      staff_member.find(staff_member_id).events
    else
      staff_event
    end
  end
end
