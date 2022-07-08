# frozen_string_literal: true

module Api
  class Deals < Grape::API
    namespace :deals do
      desc 'Get all deals list', is_array: true, success: Entities::Deal

      params do
        optional :seller_id, type: Integer, desc: 'Filter by seller_id'
        optional :buyer_id, type: Integer, desc: 'Filter by buyer id'
        optional :states, type: Array,
                          desc: 'Filter by states for example (1,3)',
                          coerce_with: ->(val) { val.split(',').map(&:to_i) }
      end

      get do
        collection = Deal.includes(
          :seller, :buyer, :deal_histories,
          offer: [:user, :currency, :balance, :payment_method, { token: [rate: :currency] }]
        )
        collection = collection.where(seller_id: params[:seller_id]) if params[:seller_id].present?
        collection = collection.where(buyer_id: params[:buyer_id]) if params[:buyer_id].present?
        collection = collection.where(state: params[:states]) if params[:states].present?
        present collection, with: Entities::Deal
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

      mount Chat
    end
  end
end
