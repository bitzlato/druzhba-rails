# frozen_string_literal: true

module Api
  module Entities
    class Token < Grape::Entity
      expose(
        :id,
        documentation: {
          type: Integer,
          desc: 'Unique token identifier in database.'
        }
      )

      expose(
        :name,
        documentation: {
          type: String,
          desc: 'A name to identify token.'
        }
      )

      expose(
        :symbol,
        documentation: {
          type: String,
          desc: 'A symbol to identify token.'
        }
      )

      expose(
        :logo,
        documentation: {
          type: String,
          desc: 'A logo url for token'
        }
      )

      expose(
        :address,
        documentation: {
          type: String,
          desc: 'Address'
        }
      )

      expose(
        :p2p_address,
        documentation: {
          type: String,
          desc: 'P2p address'
        }
      )

      expose(
        :arbiter_address,
        documentation: {
          type: String,
          desc: 'Arbiter address'
        }
      )

      expose :rate, using: Api::Entities::Rate
    end
  end
end
