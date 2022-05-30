# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offer, type: :model do
  fixtures :users, :tokens, :currencies, :balances, :payment_methods, :offers

  let(:david_usdt_offer) { offers(:david_usdt_offer) }

  describe 'validation' do
    it { expect(david_usdt_offer).to be_valid }

    it 'rate numericality' do
      david_usdt_offer.rate = 'y'

      expect(david_usdt_offer).not_to be_valid
      expect(david_usdt_offer.errors).to have_key(:rate)
    end

    it 'min numericality' do
      david_usdt_offer.min = nil

      expect(david_usdt_offer).not_to be_valid
      expect(david_usdt_offer.errors).to have_key(:min)
    end

    it 'max numericality' do
      david_usdt_offer.max = ''

      expect(david_usdt_offer).not_to be_valid
      expect(david_usdt_offer.errors).to have_key(:max)
    end
  end
end
