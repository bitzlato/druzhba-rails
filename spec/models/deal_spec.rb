# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deal, type: :model do
  fixtures :users, :tokens, :currencies, :balances, :payment_methods, :offers, :deals

  let(:david_and_adam_deal) { deals(:david_and_adam_deal) }

  describe 'validation' do
    it { expect(david_and_adam_deal).to be_valid }

    it 'fee numericality' do
      david_and_adam_deal.fee = ' '

      expect(david_and_adam_deal).not_to be_valid
      expect(david_and_adam_deal.errors).to have_key(:fee)
    end

    it 'locked numericality' do
      david_and_adam_deal.locked = nil

      expect(david_and_adam_deal).not_to be_valid
      expect(david_and_adam_deal.errors).to have_key(:locked)
    end
  end
end
