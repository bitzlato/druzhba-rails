require 'rails_helper'

RSpec.describe Balance, type: :model do
  fixtures :users, :tokens, :balances

  let(:david_usdt_balance) { balances(:david_usdt_balance) }

  describe 'validation' do
    it { expect(david_usdt_balance).to be_valid }

    it 'locked numericality' do
      david_usdt_balance.locked = 'y'

      expect(david_usdt_balance).to_not be_valid
      expect(david_usdt_balance.errors).to have_key(:locked)
    end
  end
end
