# frozen_string_literal: true

module Api
  module Helpers
    module JwtInfo
      def current_user
        @current_user ||= User.where(uid: jwt_token_payload['sub']).first_or_initialize
      end

      def current_address; end

      def jwt_token_payload
        @jwt_token_payload ||= begin
          token = headers['Authorization'].to_s.split.last
          token.present? ? JWT.decode(token, nil, false).first : {}
        end
      end
    end
  end
end
