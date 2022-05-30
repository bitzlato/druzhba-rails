require 'rails_helper'

RSpec.describe Currency, type: :model do
  fixtures :currencies

  let(:rub) { currencies(:rub) }

  describe 'validation' do
    it { expect(rub).to be_valid }

    it 'name presence' do
      rub.name = ' '

      expect(rub).to_not be_valid
      expect(rub.errors).to have_key(:name)
    end

    it 'symbol presence' do
      rub.symbol = ''

      expect(rub).to_not be_valid
      expect(rub.errors).to have_key(:symbol)
    end
  end
end
