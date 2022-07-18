# frozen_string_literal: true

module Api
  module Entities
    class DealHistory < Grape::Entity
      expose :state, documentation: { type: Integer, desc: 'History item state' }
      expose :tx_hash, documentation: { type: String, desc: 'History item tx hash' }
      expose :created_at, documentation: { type: Integer, desc: 'History Item time' } do |deal_history|
        deal_history.created_at.to_i
      end
    end
  end
end
