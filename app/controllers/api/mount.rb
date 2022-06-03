# frozen_string_literal: true

module Api
  class Mount < Grape::API
    format         :json
    content_type   :json, 'application/json'
    default_format :json

    version 'v1', using: :accept_version_header

    rescue_from ActiveRecord::RecordNotFound do |_e|
      rack_response('{ "status": 404, "message": "Not Found." }', 404)
    end

    mount Currencies
    mount PaymentMethods
    mount Tokens
    mount Offers
  end
end
