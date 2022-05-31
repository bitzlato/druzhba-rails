# frozen_string_literal: true

module Api
  class Currencies < Grape::API
    namespace :currencies do
      desc 'Get all currencies list', is_array: true, success: Entities::Currency
      get do
        present Currency.order(:id), with: Entities::Currency
      end
    end
  end
end
