# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DealHistory, type: :model do
  fixtures :users, :tokens, :currencies, :balances, :payment_methods, :offers, :deals, :deal_histories

  let(:deal_history) { deal_histories(:david_and_adam_deal_history_confirmed) }

  describe 'validation' do
    it { expect(deal_history).to be_valid }

    it 'tx_hash presence' do
      deal_history.tx_hash = ' '

      expect(deal_history).not_to be_valid
      expect(deal_history.errors).to have_key(:tx_hash)
    end

    it 'state presence' do
      deal_history.state = nil

      expect(deal_history).not_to be_valid
      expect(deal_history.errors).to have_key(:state)
    end
  end
end
