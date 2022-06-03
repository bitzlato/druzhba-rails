# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rate, type: :model do
  fixtures :currencies, :tokens, :rates

  let(:usdt_rate) { rates(:usdt_usd_rate) }

  describe 'validation' do
    it { expect(usdt_rate).to be_valid }

    it 'rate presence' do
      usdt_rate.rate = ' '

      expect(usdt_rate).not_to be_valid
      expect(usdt_rate.errors).to have_key(:rate)
    end
  end
end
