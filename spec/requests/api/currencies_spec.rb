# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Currencies, type: :request do
  fixtures :currencies

  let(:response_fields) do
    %w[
      id
      name
      symbol
      logo
    ]
  end

  describe 'GET /api/currencies' do
    it 'return array of currencies' do
      get '/api/currencies'

      expect(json_response.first.keys).to match_array(response_fields)
      expect(response.status).to eq 200
    end
  end
end
