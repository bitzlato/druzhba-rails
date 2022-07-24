# frozen_string_literal: true

module Api
  module Entities
    module UserNotifications
      class Deal < Grape::Entity
        expose :kind, proc: ->(_deal) { :deal }
        expose :object, using: Api::Entities::Deal, proc: ->(deal) { deal }
      end
    end
  end
end
