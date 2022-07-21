# frozen_string_literal: true

module Api
  module Entities
    class PaymentMethod < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Unique Method identifier in database.' }
      expose :name, documentation: { type: String, desc: 'A name to identify method' }
      expose :active, documentation: { type: 'Boolean', desc: 'If method is active' }
    end
  end
end
