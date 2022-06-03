# frozen_string_literal: true

module Api
  module Entities
    class Offer < Grape::Entity
      expose(
        :id,
        documentation: {
          type: Integer,
          desc: 'Unique offer identifier in database.'
        }
      )

      expose(
        :user_id,
        documentation: {
          type: Integer,
          desc: 'Unique user_id identifier in database.'
        }
      )

      expose(
        :rate,
        documentation: {
          type: Float,
          desc: 'Offer rate.'
        }
      )

      expose(
        :min,
        documentation: {
          type: Float,
          desc: 'Min value'
        }
      )

      expose(
        :max,
        documentation: {
          type: Float,
          desc: 'Max value'
        }
      )

      expose(
        :terms,
        documentation: {
          type: String,
          desc: 'Terms info'
        }
      )

      expose(
        :active,
        documentation: {
          type: 'Boolean',
          desc: 'Current state'
        }
      )

      expose :payment_method, using: Api::Entities::PaymentMethod, as: :method
      expose :currency, using: Api::Entities::Currency
      expose :token, using: Api::Entities::Token
    end
  end
end
