# frozen_string_literal: true

module Api
  module Entities
    class Deal < Grape::Entity
      expose(
        :id,
        documentation: {
          type: Integer,
          desc: 'Unique deal identifier in database.'
        }
      )

      expose(
        :seller_id,
        documentation: {
          type: Integer,
          desc: 'Deal seller id'
        }
      )
      expose(
        :buyer_id,
        documentation: {
          type: Integer,
          desc: 'Deal buyer id'
        }
      )
      expose(
        :fee,
        documentation: {
          type: BigDecimal,
          desc: 'Deal fee'
        }
      )

      expose(
        :locked,
        documentation: {
          type: BigDecimal,
          desc: 'Deal locked sum'
        }
      )

      expose(
        :state,
        documentation: {
          type: String,
          desc: 'Deal current state'
        }
      )

      expose(
        :in_use,
        documentation: {
          desc: 'Deal in_use state'
        }
      )

      expose :offer, using: Api::Entities::Offer
    end
  end
end
