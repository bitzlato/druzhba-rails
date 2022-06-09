# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageBuilder do
  fixtures :users, :deals, :offers, :tokens, :chats, :messages

  let(:builder) { described_class.new(author: author, deal: deal, message: message, to: to) }
  let(:author) { users(:david) }
  let(:deal) { deals(:david_and_adam_deal) }
  let(:message) { 'Text' }
  let(:to) { :arbiter }

  describe '#save' do
    context 'when deal chat not exist' do
      let(:deal) { deals(:david_and_piter_deal) }

      it 'creates chat for deal' do
        expect { builder.save }
          .to change { Chat.where(deal: deal).count }.by(1)
          .and change { author.messages.arbiter.count }.by(1)
      end

      it 'broadcast message to arbiter' do
        expect { builder.save }.to have_broadcasted_to("deal_#{deal.id}_chat_for_#{users(:arbiter).uid}")
      end
    end

    context 'when validating to' do
      let(:to) { 'seller' }

      it 'disable sent private messages to buyer or seller for them' do
        expect { builder.save }.to change { author.messages.where(to: :both).count }.by(1)
      end
    end
  end
end
