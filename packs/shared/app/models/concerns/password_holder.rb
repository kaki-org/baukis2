# pack_public: true
# frozen_string_literal: true

module PasswordHolder
  extend ActiveSupport::Concern

  def password=(raw_password)
    if raw_password.is_a?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
