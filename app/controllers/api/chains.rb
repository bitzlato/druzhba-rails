# frozen_string_literal: true

module Api
  class Chains < Grape::API
    namespace :chains do
      desc 'Get all chains list', is_array: true, success: Entities::Chain
      get do
        present Chain.order(:id), with: Entities::Chain
      end

      desc 'Get chain info', success: Entities::Chain
      get '/:id' do
        chain = Chain.find(params[:id])
        present chain, with: Entities::Chain
      end
    end
  end
end
