# frozen_string_literal: true

module Api
  class PaymentMethods < Grape::API
    namespace :methods do
      desc 'Get all methods list', is_array: true, success: Entities::PaymentMethod
      get do
        present PaymentMethod.order(:id), with: Entities::PaymentMethod
      end
    end
  end
end
