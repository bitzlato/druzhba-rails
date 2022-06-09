# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  fixtures :chats, :messages

  let(:message) { messages(:adam_message) }

  describe 'validation' do
    it { expect(message).to be_valid }

    it 'message presence' do
      message.message = ' '

      expect(message).not_to be_valid
      expect(message.errors).to have_key(:message)
    end

    it 'file presence' do
      message = messages(:piter_file_message)
      message.file = nil

      expect(message).not_to be_valid
      expect(message.errors).to have_key(:file)
    end

    it 'file_title presence' do
      message = messages(:piter_file_message)
      message.file_title = nil

      expect(message).not_to be_valid
      expect(message.errors).to have_key(:file_title)
    end
  end
end
