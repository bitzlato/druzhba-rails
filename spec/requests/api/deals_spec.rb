# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Deals, type: :request do
  fixtures :currencies, :tokens, :rates, :users, :payment_methods, :balances, :offers, :deals
  let(:deal) { deals(:david_and_adam_deal) }

  let(:response_fields) do
    %w[
      id
      buyer_address
      seller_address
      offer
      state
      fee
      locked
      in_use
      created_at
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

  describe 'POST /api/deals' do
    let(:post_request) do
      post '/api/deals', params: deals_params
    end

    let(:deals_params) do
      {
        seller_id: users(:adam).id,
        buyer_id: users(:david).id,
        offer_id: offers(:adam_usdt_offer).id,
        fee: 0.05,
        locked: 10,
        in_use: true
      }
    end

    context 'with valid attributes' do
      it 'create new deal' do
        expect { post_request }.to change(Deal, :count).by(1)
        expect(json_response.keys).to match_array(response_fields)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid attributes' do
      before do
        deals_params[:fee] = ''
      end

      it 'render error message' do
        expect { post_request }.not_to change(Deal, :count)
        expect(json_response['error']).to eq 'Fee is not a number'
        expect(response.status).to eq 422
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
