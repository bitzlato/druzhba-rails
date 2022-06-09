# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  fixtures :chats, :messages, :users

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

  describe '#available_for?' do
    let(:arbiter) { users(:arbiter) }
    let(:seller) { users(:david) }
    let(:buyer) { users(:adam) }
    let(:chat) { chats(:david_and_adam_deal_chat) }

    context 'when seller public message to buyer' do
      let(:message) { messages(:adam_message) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).to be_available_for(buyer) }
      it { expect(message).to be_available_for(seller) }
    end

    context 'when buyer public message to seller' do
      let(:message) { messages(:david_message) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).to be_available_for(buyer) }
      it { expect(message).to be_available_for(seller) }
    end

    context 'when seller private message to arbiter' do
      let(:message) { described_class.new(author: seller, to: :arbiter, chat: chat) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).not_to be_available_for(buyer) }
      it { expect(message).to be_available_for(seller) }
    end

    context 'when buyer private message to arbiter' do
      let(:message) { described_class.new(author: buyer, to: :arbiter, chat: chat) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).to be_available_for(buyer) }
      it { expect(message).not_to be_available_for(seller) }
    end

    context 'when arbiter private message to seller' do
      let(:message) { messages(:arbiter_message_to_david) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).not_to be_available_for(buyer) }
      it { expect(message).to be_available_for(seller) }
    end

    context 'when arbiter private message to buyer' do
      let(:message) { messages(:arbiter_message_to_adam) }

      it { expect(message).to be_available_for(arbiter) }
      it { expect(message).to be_available_for(buyer) }
      it { expect(message).not_to be_available_for(seller) }
    end
  end
end
