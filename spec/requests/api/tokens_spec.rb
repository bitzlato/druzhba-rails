# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Tokens, type: :request do
  fixtures :chains, :currencies, :tokens, :rates
  let(:token) { tokens(:usdt) }

  let(:response_fields) do
    %w[
      id
      name
      symbol
      logo
      address
      arbiter_address
      p2p_address
      rate
      decimals
      fee
    ]
  end

  let(:rate_fields) do
    %w[
      value
      currency
    ]
  end

  describe 'GET /api/tokens' do
    it 'return array of tokens with rate' do
      get '/api/tokens'

      expect(json_response.first.keys).to match_array(response_fields)
      expect(json_response.first['rate'].keys).to match_array(rate_fields)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /api/tokens/:id' do
    it 'return token full info with rate' do
      get "/api/tokens/#{token.id}"

      expect(json_response.keys).to match_array(response_fields)
      expect(json_response).to include('id' => token.id)
      expect(response.status).to eq 200
    end
  end
end
