# frozen_string_literal: true

module Api
  module Entities
    class Deal < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Unique deal identifier in database.' }
      expose :internal_id, documentation: { type: Integer, desc: 'Unique current deal id in contract' }
      expose :fee, documentation: { type: BigDecimal, desc: 'Deal fee' }
      expose :locked, documentation: { type: BigDecimal, desc: 'Deal locked sum' }
      expose :in_use, documentation: { desc: 'Deal in_use state' }
      expose :seller_address, documentation: { type: String, desc: 'Deal seller address' } do |deal|
        deal.seller.eth_address
      end
      expose :buyer_address, documentation: { type: String, desc: 'Deal buyer address' } do |deal|
        deal.buyer.eth_address
      end
      expose :state, documentation: { type: String, desc: 'Deal current state' }, &:state_before_type_cast
      expose :created_at, documentation: { type: Integer, desc: 'Deal created_at time in timestamp' } do |deal|
        deal.created_at.to_i
      end
      expose :deadline_at, documentation: { type: Integer, desc: 'Deal deadline_at time in timestamp' } do |deal|
        deal.deadline_at.to_i
      end
      expose :signature, documentation: { type: String, desc: 'Deal signature' }
      expose :offer, using: Api::Entities::Offer
      expose :history, documentation: { type: Array, desc: 'Array of history entities' },
                       using: Api::Entities::DealHistory, proc: ->(deal) { deal.deal_histories.ordered }
    end
  end
end
