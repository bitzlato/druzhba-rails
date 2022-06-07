# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  fixtures :chats, :messages

  let(:message) { messages(:adam_message) }

  describe 'validation' do
    it { expect(message).to be_valid }

    it 'name presence' do
      message.message = ' '

      expect(message).not_to be_valid
      expect(message.errors).to have_key(:message)
    end
  end
end
