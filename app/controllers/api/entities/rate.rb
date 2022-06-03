# frozen_string_literal: true

module Api
  module Entities
    class Rate < Grape::Entity
      expose :value, documentation: { type: Float, desc: 'Currency rate value' } do |instance, _|
        instance.rate
      end

      expose :currency, documentation: { type: String, desc: 'A name of currency' } do |instance, _|
        instance.currency.name
      end
    end
  end
end
