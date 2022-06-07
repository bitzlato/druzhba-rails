# frozen_string_literal: true

module Api
  class Offers < Grape::API
    namespace :offers do
      desc 'Get all offers list', is_array: true, success: Entities::Offer

      params do
        optional :active, type: Boolean, desc: 'Filter by status'
        optional :user_id, type: Integer, desc: 'Filter by user_id'
        optional :token_id, type: Integer, desc: 'Filter by token_id'
        optional :currency_id, type: Integer, desc: 'Filter by currency_id'
        optional :method_id, type: Integer, desc: 'Filter by method id'
        optional :sort_by_desc, type: String, values: %w[created_at updated_at rate], desc: 'Filter by desc field name'
        optional :sort_by_asc, type: String, values: %w[created_at updated_at rate], desc: 'Filter by asc field name'
      end

      get do
        collection = Offer.includes(:currency, :balance, :payment_method, token: [rate: :currency])
        collection = collection.where(user_id: params[:user_id]) if params[:user_id].present?
        collection = collection.where(token_id: params[:token_id]) if params[:token_id].present?
        collection = collection.where(payment_method_id: params[:method_id]) if params[:method_id].present?
        collection = collection.where(currency_id: params[:currency_id]) if params[:currency_id].present?
        collection = collection.order(params[:sort_by_desc] => :desc) if params[:sort_by_desc].present?
        collection = collection.order(params[:sort_by_asc] => :desc) if params[:sort_by_asc].present?

        present collection, with: Entities::Offer
      end

      desc 'Create new offer', success: Entities::Offer

      params do
        requires :user_id, type: Integer, desc: 'Offer user_id'
        requires :token_id, type: Integer, desc: 'Offer token_id'
        requires :currency_id, type: Integer, desc: 'Offer currency_id'
        requires :method_id, type: Integer, desc: 'Offer method id'
        requires :balance_id, type: Integer, desc: 'Offer balance id'
        requires :active, type: Boolean, desc: 'Offer active state'
        requires :rate, type: Float, desc: 'Offer rate'
        requires :min, type: Float, desc: 'Min offer'
        requires :max, type: Float, desc: 'Max offer '
        requires :terms, type: String, desc: 'Offer terms'
      end

      post do
        params[:payment_method_id] = params.delete(:method_id)
        offer = Offer.new(params)
        if offer.save
          present offer, with: Entities::Offer
        else
          error!({ error: offer.errors.full_messages.join(', ') }, 422)
        end
      end

      desc 'Get offer info', success: Entities::Offer
      get '/:id' do
        offer = Offer.find(params[:id])
        present offer, with: Entities::Offer
      end

      desc 'Update offer info', success: Entities::Offer
      params do
        requires :active, type: Boolean, desc: 'New active state'
      end
      put '/:id' do
        offer = Offer.find(params[:id])
        if offer.update(active: params[:active])
          present offer, with: Entities::Offer
        else
          error!({ error_message: offer.errors.full_messages.join(', ') }, 422)
        end
      end
    end
  end
end