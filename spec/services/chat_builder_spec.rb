# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatBuilder do
  fixtures :users, :deals, :offers, :tokens, :chats, :messages

  let(:builder) { described_class.new(deal, user, filter_params) }
  let(:filter_params) { { limit: 20, page: 1, with: with } }
  let(:deal) { deals(:david_and_adam_deal) }
  let(:with) { nil }

  describe '#messages' do
    describe 'pagination works' do
      let(:user) { users(:adam) }
      let(:filter_params) { { limit: 1, page: 2 } }

      it { expect(builder.messages).to eq [messages(:david_message)] }
    end

    describe 'filter works' do
      context 'when user arbiter' do
        let(:user) { users(:arbiter) }

        context 'when with seller params' do
          let(:with) { 'seller' }

          it do
            expect(builder.messages).to eq [
              messages(:arbiter_message_to_david),
              messages(:david_message),
              messages(:adam_message)
            ]
          end
        end

        context 'when with buyer params' do
          let(:with) { 'buyer' }

          it do
            expect(builder.messages).to eq [
              messages(:arbiter_message_to_adam),
              messages(:david_message),
              messages(:adam_message)
            ]
          end
        end
      end

      context 'when user buyer' do
        let(:user) { users(:adam) }

        it do
          expect(builder.messages).to eq [
            messages(:arbiter_message_to_adam),
            messages(:david_message),
            messages(:adam_message)
          ]
        end
      end

      context 'when user seller' do
        let(:user) { users(:david) }

        it do
          expect(builder.messages).to eq [
            messages(:arbiter_message_to_david),
            messages(:david_message),
            messages(:adam_message)
          ]
        end
      end
    end
  end
end
