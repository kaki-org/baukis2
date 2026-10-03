# pack_public: true
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :set_layout

  # append_view_path(Rails.root.glob('app/packages/*/views')) # 追記
  class Forbidden < ActionController::ActionControllerError; end

  class IpAddressRejected < ActionController::ActionControllerError; end
  include ErrorHandlers if Rails.env.production?

  private

  def set_layout
    if params[:controller].match(%r{\A(staff|admin|customer)/})
      Regexp.last_match[1]
    else
      'customer'
    end
  end
end
