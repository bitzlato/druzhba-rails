# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Chat api', type: :request do
  fixtures :users, :deals, :offers, :tokens, :chats, :messages

  let(:deal) { deals(:david_and_adam_deal) }

  let(:chat_fields) do
    %w[
      data
      total
    ]
  end

  let(:message_fields) do
    %w[
      id
      type
      created_at
      message
      author_id
    ]
  end

  describe 'GET /api/deals/:id/chat' do
    let(:get_chat) { get "/api/deals/#{deal.id}/chat" }

    context 'when user is empty in token' do
      it 'return 403 error message' do
        get_chat
        expect(response.status).to eq 403
        expect(json_response['error_message']).to eq 'User is not member of a deal'
      end
    end

    context 'when user from token is not a member of a deal' do
      let(:get_chat) { get "/api/deals/#{deal.id}/chat", headers: jwt_header_for(users(:piter)) }

      it 'return 403 error message' do
        get_chat
        expect(response.status).to eq 403
        expect(json_response['error_message']).to eq 'User is not member of a deal'
      end
    end

    context 'when user from token is member of a deal' do
      let(:get_chat) { get "/api/deals/#{deal.id}/chat", headers: jwt_header_for(users(:adam)) }

      it 'return array of messages' do
        get_chat
        expect(json_response.keys).to match_array(chat_fields)
        expect(json_response['data'].first.keys).to match_array(message_fields)
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST /api/deals/:id/chat' do
    let(:message_params) { { message: 'Hi' } }

    context 'when user is empty token' do
      let(:post_message) do
        post "/api/deals/#{deal.id}/chat", params: message_params
      end

      it 'return 403 error message' do
        post_message
        expect(response.status).to eq 403
        expect(json_response['error_message']).to eq 'User is not member of a deal'
      end
    end

    context 'when user from token is not a member of a deal' do
      let(:post_message) do
        post "/api/deals/#{deal.id}/chat", params: message_params, headers: jwt_header_for(users(:piter))
      end

      it 'return 403 error message' do
        post_message
        expect(response.status).to eq 403
        expect(json_response['error_message']).to eq 'User is not member of a deal'
      end
    end

    context 'when user from token is member of a deal' do
      let(:post_message) do
        post "/api/deals/#{deal.id}/chat", params: message_params, headers: jwt_header_for(users(:adam))
      end

      context 'with invalid params' do
        let(:message_params) { { message: '' } }

        it 'render error message' do
          expect { post_message }.not_to change(Message, :count)
          expect(response.status).to eq 422
          expect(json_response['error_message']).to match(/Message can't be blank/)
        end
      end

      context 'with valid params' do
        it 'creates new message' do
          expect { post_message }.to change(users(:adam).messages, :count).by(1)
          expect(response.status).to eq 201
          expect(json_response.keys).to match_array(message_fields)
        end
      end
    end

    describe 'POST /api/deals/:id/chat/sendfile' do
      let(:message_params) { { file: fixture_file_upload('photo.png'), name: 'Image png' } }

      context 'when user is empty token' do
        let(:post_message_file) do
          post "/api/deals/#{deal.id}/chat/sendfile", params: message_params
        end

        it 'return 403 error message' do
          post_message_file
          expect(response.status).to eq 403
          expect(json_response['error_message']).to eq 'User is not member of a deal'
        end
      end

      context 'when user from token is not a member of a deal' do
        let(:post_message_file) do
          post "/api/deals/#{deal.id}/chat/sendfile", params: message_params, headers: jwt_header_for(users(:piter))
        end

        it 'return 403 error message' do
          post_message_file
          expect(response.status).to eq 403
          expect(json_response['error_message']).to eq 'User is not member of a deal'
        end
      end

      context 'when user from token is member of a deal' do
        let(:post_message_file) do
          post "/api/deals/#{deal.id}/chat/sendfile", params: message_params, headers: jwt_header_for(users(:adam))
        end

        context 'with invalid params' do
          let(:message_params) { { file: fixture_file_upload('photo.png'), name: '' } }

          it 'render error message' do
            expect { post_message_file }.not_to change(Message, :count)
            expect(response.status).to eq 422
            expect(json_response['error_message']).to match(/File title can't be blank/)
          end
        end

        context 'with valid params' do
          it 'creates new message' do
            expect { post_message_file }.to change(users(:adam).messages, :count).by(1)
            expect(response.status).to eq 201
            expect(json_response.keys).to match_array(message_fields + ['file'])
          end
        end
      end
    end
  end
end
