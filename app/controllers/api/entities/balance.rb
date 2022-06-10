# frozen_string_literal: true

module Api
  module Entities
    class Balance < Grape::Entity
      expose(
        :locked,
        documentation: {
          type: BigDecimal,
          desc: 'Locked balance'
        }
      )
    end
  end
end
