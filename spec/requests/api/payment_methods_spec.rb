# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PaymentMethods, type: :request do
  fixtures :payment_methods

  let(:response_fields) do
    %w[
      id
      name
      active
    ]
  end

  describe 'GET /api/methods' do
    it 'return array of payment methods' do
      get '/api/methods'

      expect(json_response.first.keys).to match_array(response_fields)
      expect(response.status).to eq 200
    end
  end
end
