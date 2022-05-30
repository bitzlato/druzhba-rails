# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  fixtures :payment_methods

  let(:by_card) { payment_methods(:by_card) }

  describe 'validation' do
    it { expect(by_card).to be_valid }

    it 'name presence' do
      by_card.name = ' '

      expect(by_card).not_to be_valid
      expect(by_card.errors).to have_key(:name)
    end
  end
end
