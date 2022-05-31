# frozen_string_literal: true

module Api
  module Entities
    class Currency < Grape::Entity
      expose(
        :id,
        documentation: {
          type: Integer,
          desc: 'Unique currency identifier in database.'
        }
      )

      expose(
        :name,
        documentation: {
          type: String,
          desc: 'A name to identify currency.'
        }
      )

      expose(
        :symbol,
        documentation: {
          type: String,
          desc: 'A symbol to identify currency.'
        }
      )

      expose(
        :logo,
        documentation: {
          type: String,
          desc: 'A logo url for currency'
        }
      )
    end
  end
end
