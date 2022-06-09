# frozen_string_literal: true

module Api
  class Chat < Grape::API
    before do
      @deal = Deal.find(params[:id])
      unless current_user.persisted? && current_user.member_of?(@deal)
        error!({ error_message: 'User is not member of a deal' }, 403)
      end
    end

    desc 'Get deal chat', success: Entities::Chat
    params do
      optional :limit, type: Integer, desc: 'Limit for per page', default: 20
      optional :page, type: Integer, desc: 'Number of a page', default: 1
      optional :with, type: String,
                      desc: 'Filter for arbiter messages list',
                      values: %w[seller buyer],
                      default: 'seller'
    end

    get '/:id/chat' do
      chat = ::ChatBuilder.new(@deal, current_user, params.slice(:limit, :page, :with))
      present chat, with: Entities::Chat, requester: current_user
    end

    desc 'Create message in deal chat', success: Entities::Message
    params do
      requires :message, type: String, desc: 'Text of message'
      optional :to, type: String, desc: 'Message recipient if its chat with arbiter', values: %w[arbiter seller buyer]
    end

    post '/:id/chat' do
      builder = MessageBuilder.new(
        params.slice(:message, :to)
              .merge(author: current_user, deal: @deal)
              .symbolize_keys
      )
      if builder.save
        present builder.new_message, with: Entities::Message, requester: current_user
      else
        error!({ error_message: builder.new_message.errors.full_messages.join(', ') }, 422)
      end
    end

    desc 'Create file in a deal chat', success: Entities::Message
    params do
      requires :name, type: String, desc: 'File title'
      requires :file, type: File, desc: 'File'
      optional :to, type: String, desc: 'Message recipient if its chat with arbiter', values: %w[arbiter seller buyer]
    end

    post '/:id/chat/sendfile' do
      builder = MessageFileBuilder.new(
        params.slice(:file, :name, :to)
              .merge(author: current_user, deal: @deal)
              .symbolize_keys
      )
      if builder.save
        present builder.new_message, with: Entities::Message, requester: current_user
      else
        error!({ error_message: builder.new_message.errors.full_messages.join(', ') }, 422)
      end
    end
  end
end
