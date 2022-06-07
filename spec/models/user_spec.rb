# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users, :deals

  let(:user) { users(:david) }

  describe 'validation' do
    it { expect(user).to be_valid }

    it 'eth_address presence' do
      user.eth_address = nil

      expect(user).not_to be_valid
      expect(user.errors).to have_key(:eth_address)
    end
  end

  describe '#member_of?' do
    let(:deal) { deals(:david_and_adam_deal) }

    context 'when user is seller' do
      let(:user) { users(:david) }

      it { expect(user).to be_member_of(deal) }
    end

    context 'when user is buyer' do
      let(:user) { users(:adam) }

      it { expect(user).to be_member_of(deal) }
    end

    context 'when user is arbiter' do
      let(:user) { users(:arbiter) }

      it { expect(user).to be_member_of(deal) }
    end

    context 'when not member' do
      let(:user) { users(:piter) }

      it { expect(user).not_to be_member_of(deal) }
    end
  end
end
