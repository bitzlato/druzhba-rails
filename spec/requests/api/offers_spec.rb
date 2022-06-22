# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Offers, type: :request do
  fixtures :currencies, :tokens, :rates, :users, :payment_methods, :balances, :offers
  let(:offer) { offers(:david_usdt_offer) }

  let(:offer_fields) do
    %w[
      id
      user_id
      method
      currency
      rate
      min
      max
      terms
      token
      active
      address
      balance
      created_at
    ]
  end

  describe 'GET /api/offers' do
    let(:get_offers) { get '/api/offers', params: params }
    let(:params) { {} }

    it 'return array of offers' do
      get_offers
      expect(json_response.first.keys).to match_array(offer_fields)
      expect(response.status).to eq 200
    end

    context 'when pass filter options' do
      let(:params) { { currency_id: currencies(:usd).id } }

      it 'filter by currency_id' do
        get_offers
        expect(json_response.size).to eq 1
        expect(json_response.first).to include('id' => offers(:adam_usdt_offer).id)
      end
    end

    context 'when pass sort options' do
      let(:params) { { sort_by_desc: :rate } }

      it 'sort by rate' do
        get_offers
        expect(json_response.map { |o| o['rate'] }).to eq ['63.0', '0.95']
      end
    end
  end

  describe 'POST /api/offers' do
    let(:post_request) do
      post '/api/offers', params: offer_params, headers: jwt_header_for(users(:david))
    end

    let(:offer_params) do
      {
        active: true,
        token_id: tokens(:usdt).id,
        currency_id: currencies(:rub).id,
        method_id: payment_methods(:by_card).id,
        rate: 0.9,
        min: 10,
        max: 20,
        terms: 'By phone number'
      }
    end

    context 'with valid attributes' do
      it 'create new offer' do
        expect { post_request }.to change(Offer, :count).by(1)
        expect(json_response.keys).to match_array(offer_fields)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid attributes' do
      before do
        offer_params[:method_id] = nil
      end

      it 'render error message' do
        expect { post_request }.not_to change(Offer, :count)
        expect(json_response['error']).to eq 'Payment method must exist'
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET /api/offers/:id' do
    it 'return offer full info' do
      get "/api/offers/#{offer.id}"

      expect(json_response.keys).to match_array(offer_fields)
      expect(json_response).to include('id' => offer.id)
      expect(response.status).to eq 200
    end
  end

  describe 'PUT /api/offers/:id' do
    it 'update offer state' do
      expect { put "/api/offers/#{offer.id}", params: { active: false } }.to change { offer.reload.active }.to(false)
      expect(json_response.keys).to match_array(offer_fields)
      expect(response.status).to eq 200
    end
  end

  describe 'PUT /api/offers/:id/accept' do
    let(:offer) { offers(:adam_usdt_offer) }
    let(:put_request) do
      put "/api/offers/#{offer.id}/accept", params: accept_params, headers: jwt_header_for(users(:piter))
    end

    let(:accept_params) do
      {
        locked: 10
      }
    end

    context 'with valid attributes' do
      it 'create new deal' do
        expect { put_request }.to change(Deal, :count).by(1)
        expect(json_response).to include('internal_id' => 1)
        expect(response.status).to eq 200
      end
    end

    context 'with invalid attributes' do
      before do
        accept_params[:locked] = ''
      end

      it 'render error message' do
        expect { put_request }.not_to change(Deal, :count)
        expect(json_response['error']).to eq 'Locked is not a number'
        expect(response.status).to eq 422
      end
    end
  end
end
