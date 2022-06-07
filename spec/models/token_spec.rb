# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token, type: :model do
  fixtures :tokens, :users

  let(:usdt) { tokens(:usdt) }

  describe 'validation' do
    it { expect(usdt).to be_valid }

    it 'name presence' do
      usdt.name = ' '

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:name)
    end

    it 'symbol presence' do
      usdt.symbol = ''

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:symbol)
    end

    it 'address presence' do
      usdt.address = ' '

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:address)
    end

    it 'p2p_address presence' do
      usdt.p2p_address = nil

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:p2p_address)
    end

    it 'arbiter_address presence' do
      usdt.arbiter_address = ' '

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:arbiter_address)
    end

    it 'chain_id numerical' do
      usdt.chain_id = 'x'

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:chain_id)
    end

    it 'decimals numerical' do
      usdt.decimals = ''

      expect(usdt).not_to be_valid
      expect(usdt.errors).to have_key(:decimals)
    end
  end

  describe '#arbiter' do
    it { expect(usdt.arbiter).to eq users(:arbiter) }
  end
end
