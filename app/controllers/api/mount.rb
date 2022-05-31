# frozen_string_literal: true

module Api
  class Mount < Grape::API
    format         :json
    content_type   :json, 'application/json'
    default_format :json

    version 'v1', using: :accept_version_header

    mount Currencies
  end
end
