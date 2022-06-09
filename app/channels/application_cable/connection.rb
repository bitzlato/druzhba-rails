# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      decoded_token = JWT.decode(request.params[:token], nil, false).first
      if (current_user = User.find_by(uid: decoded_token['sub']))
        current_user
      else
        reject_unauthorized_connection
      end
    rescue StandardError
      reject_unauthorized_connection
    end
  end
end
