# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Chains, type: :request do
  fixtures :chains
  let(:chain) { chains(:goerli) }

  let(:response_fields) do
    %w[
      id
      name
      explorer_address
      explorer_token
      explorer_tx
      metamask_rpc
    ]
  end

  describe 'GET /api/chains' do
    it 'return array of chains with rate' do
      get '/api/chains'

      expect(json_response.first.keys).to match_array(response_fields)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /api/chains/:id' do
    it 'return chain full info with rate' do
      get "/api/chains/#{chain.id}"

      expect(json_response.keys).to match_array(response_fields)
      expect(json_response).to include('id' => chain.id)
      expect(response.status).to eq 200
    end
  end
end
