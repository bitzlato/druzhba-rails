# frozen_string_literal: true

module Admin
  class TokensController < ApplicationController
    def index
      tokens = paginate Token.includes(:chain)
      render locals: { tokens: tokens }
    end

    def new
      token = Token.new
      render locals: { token: token }
    end

    def create
      token = Token.new(token_params)
      token.save!
      redirect_to admin_tokens_path, notice: t('notices.created')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? Token

      render :new, locals: { token: token }
    end

    def edit
      token = Token.find(params[:id])
      render locals: { token: token }
    end

    def update
      token = Token.find(params[:id])
      token.update!(token_params)
      redirect_to admin_tokens_path, notice: t('notices.updated')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? Token

      render :edit, locals: { token: token }
    end

    def destroy
      token = Token.find(params[:id])
      token.destroy!
      redirect_back(fallback_location: admin_tokens_path, notice: t('notices.updated'))
    rescue ActiveRecord::DeleteRestrictionError
      redirect_back(fallback_location: admin_tokens_path, alert: t('alerts.destroyed'))
    end

    private

    def token_params
      params.require(:token).permit(:name, :explorer_address, :explorer_token, :explorer_tx, :metamask_rpc)
    end
  end
end
