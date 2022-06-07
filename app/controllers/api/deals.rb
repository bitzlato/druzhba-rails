# frozen_string_literal: true

module Api
  class Deals < Grape::API
    namespace :deals do
      desc 'Get all deals list', is_array: true, success: Entities::Deal

      params do
        optional :seller_id, type: Integer, desc: 'Filter by seller_id'
        optional :buyer_id, type: Integer, desc: 'Filter by by id'
        optional :states, type: Array[String], desc: 'Filter by states'
      end

      get do
        collection = Deal.includes(offer: [:currency, :balance, :payment_method, { token: [rate: :currency] }])
        collection = collection.where(seller_id: params[:seller_id]) if params[:seller_id].present?
        collection = collection.where(buyer_id: params[:buyer_id]) if params[:buyer_id].present?
        collection = collection.where(state: params[:states]) if params[:states].present?
        present collection, with: Entities::Deal
      end

      desc 'Create new deal', success: Entities::Deal

      params do
        requires :seller_id, type: Integer, desc: 'Deal seller_id'
        requires :buyer_id, type: Integer, desc: 'Deal buyer_uid'
        requires :offer_id, type: Integer, desc: 'Deal offer_id'
        requires :fee, type: BigDecimal, desc: 'Deal fee'
        requires :locked, type: BigDecimal, desc: 'Deal locked'
        optional :in_use, type: Boolean, desc: 'Deal in_use boolen state'
      end

      post do
        deal = Deal.new(params)
        if deal.save
          present deal, with: Entities::Deal
        else
          error!({ error: deal.errors.full_messages.join(', ') }, 422)
        end
      end

      desc 'Get deal info', success: Entities::Deal
      get '/:id' do
        deal = Deal.find(params[:id])
        present deal, with: Entities::Deal
      end

      desc 'Update deal status', success: Entities::Deal
      params do
        requires :state, type: String, desc: 'New state'
      end
      put '/:id' do
        deal = Deal.find(params[:id])
        if deal.update(state: params[:state])
          present deal, with: Entities::Deal
        else
          error!({ error_message: deal.errors.full_messages.join(', ') }, 422)
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
        deal = Deal.find(params[:id])
        if current_user.persisted? && current_user.member_of?(deal)
          chat = ::ChatBuilder.new(deal, current_user, params.slice(:limit, :page, :with))
          present chat, with: Entities::Chat, requester: current_user
        else
          error!({ error_message: 'User is not member of a deal' }, 403)
        end
      end

      desc 'Create message in deal chat', success: Entities::Message
      params do
        requires :message, type: String, desc: 'Text of message'
        optional :to, type: String, desc: 'Message recipient if its chat with arbiter', values: %w[arbiter seller buyer]
      end

      post '/:id/chat' do
        deal = Deal.find(params[:id])
        if current_user.persisted? && current_user.member_of?(deal)
          builder = MessageBuilder.new(
            params.slice(:message, :to)
                  .merge(author: current_user, deal: deal)
                  .symbolize_keys
          )
          if builder.save
            present builder.new_message, with: Entities::Message, requester: current_user
          else
            error!({ error_message: builder.new_message.errors.full_messages.join(', ') }, 422)
          end
        else
          error!({ error_message: 'User is not member of a deal' }, 403)
        end
      end
    end
  end
end
