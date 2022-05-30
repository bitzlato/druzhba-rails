require 'rails_helper'

RSpec.describe DealHistory, type: :model do
  fixtures :users, :tokens, :currencies, :balances, :payment_methods, :offers, :deals, :deal_histories

  let(:deal_history) { deal_histories(:david_and_adam_deal_confirmed) }

  describe 'validation' do
    it { expect(deal_history).to be_valid }

    it 'hash presence' do
      deal_history.hash = ' '

      expect(deal_history).to_not be_valid
      expect(deal_history.errors).to have_key(:hash)
    end

    it 'time presence' do
      deal_history.time = ''

      expect(deal_history).to_not be_valid
      expect(deal_history.errors).to have_key(:time)
    end

    it 'state presence' do
      deal_history.state = nil

      expect(deal_history).to_not be_valid
      expect(deal_history.errors).to have_key(:state)
    end
  end
end
