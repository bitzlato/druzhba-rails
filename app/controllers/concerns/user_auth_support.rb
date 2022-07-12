# frozen_string_literal: true

module UserAuthSupport
  extend ActiveSupport::Concern

  included do
    before_action :require_login

    def not_authenticated
      flash_alert! :not_authenticated
      redirect_to new_session_url
    end
  end
end
