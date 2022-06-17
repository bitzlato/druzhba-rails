# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AcceptOffer do
  describe '#call' do
    fixtures :users, :offers

    let(:buyer) { users(:adam) }
    let(:offer) { offers(:david_usdt_offer) }

    let(:accepter) { described_class.new(offer, deal_params) }

    context 'with valid attributes' do
      let(:deal_params) do
        {
          buyer: buyer,
          locked: 1,
          fee: 0.1
        }
      end

      it 'create new valid deal with internal id and signature' do
        expect { accepter.call }.to change(Deal, :count).by(1)
        expect(accepter.deal.attributes).to include('internal_id' => 1, 'signature' => kind_of(String))
      end
    end

    context 'with invalid attributes' do
      let(:deal_params) do
        {
          buyer: nil,
          locked: 1,
          fee: 0.1
        }
      end

      it 'not create deal' do
        expect { accepter.call }.not_to change(Deal, :count)
        expect(accepter.deal.errors.attribute_names).to include(:buyer)
      end
    end
  end
end
