require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :users

  let(:user) { users(:david) }

  describe 'validation' do
    it { expect(user).to be_valid }

    it 'eth_address presence' do
      user.eth_address = nil

      expect(user).to_not be_valid
      expect(user.errors).to have_key(:eth_address)
    end
  end
end
