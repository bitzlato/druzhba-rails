# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Deals, type: :request do
  fixtures :currencies, :tokens, :rates, :users, :payment_methods, :balances, :offers, :deals
  let(:deal) { deals(:david_and_adam_deal) }

  let(:response_fields) do
    %w[
      id
      internal_id
      buyer_address
      seller_address
      offer
      state
      fee
      history
      locked
      created_at
      deadline_at
      signature
    ]
  end

  describe 'GET /api/deals' do
    it 'return array of offers' do
      get '/api/deals'
      expect(json_response.first.keys).to match_array(response_fields)
      expect(response.status).to eq 200
    end

    context 'when filter by state and seller' do
      it 'return filtered collection' do
        get '/api/deals', params: { buyer_id: users(:adam).id, status: 0 }

        expect(json_response.size).to eq 1
        expect(json_response.first).to include('id' => deal.id)
      end
    end
  end

  describe 'GET /api/deals/:id' do
    it 'return offer full info' do
      get "/api/deals/#{deal.id}"

      expect(json_response.keys).to match_array(response_fields)
      expect(json_response).to include('id' => deal.id)
      expect(response.status).to eq 200
    end
  end

  describe 'PUT /api/deals/:id' do
    it 'update deal state' do
      expect { put "/api/deals/#{deal.id}", params: { state: 'started' } }.to change {
                                                                                deal.reload.state
                                                                              }.to('started')
      expect(json_response.keys).to match_array(response_fields)
      expect(response.status).to eq 200
    end
  end
end
