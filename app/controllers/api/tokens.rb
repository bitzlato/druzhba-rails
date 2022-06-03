# frozen_string_literal: true

module Api
  class Tokens < Grape::API
    namespace :tokens do
      desc 'Get all tokens list', is_array: true, success: Entities::Token
      get do
        present Token.includes(rate: :currency).order(:id), with: Entities::Token
      end

      desc 'Get token info', success: Entities::Token
      get '/:id' do
        token = Token.find(params[:id])
        present token, with: Entities::Token
      end
    end
  end
end
