# frozen_string_literal: true

module Admin
  class ChainsController < ApplicationController
    def index
      chains = paginate Chain
      render locals: { chains: chains }
    end

    def new
      chain = Chain.new
      render locals: { chain: chain }
    end

    def create
      chain = Chain.new(chain_params)
      chain.save!
      redirect_to admin_chains_path, notice: t('notices.created')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? Chain

      render :new, locals: { chain: chain }
    end

    def edit
      chain = Chain.find(params[:id])
      render locals: { chain: chain }
    end

    def update
      chain = Chain.find(params[:id])
      chain.update!(chain_params)
      redirect_to admin_chains_path, notice: t('notices.updated')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? Chain

      render :edit, locals: { chain: chain }
    end

    def destroy
      chain = Chain.find(params[:id])
      chain.destroy!
      redirect_back(fallback_location: admin_chains_path, notice: t('notices.updated'))
    rescue ActiveRecord::DeleteRestrictionError
      redirect_back(fallback_location: admin_chains_path, alert: t('alerts.destroyed'))
    end

    private

    def chain_params
      params.require(:chain).permit(
        :name, :chain_id, :chain_type, :explorer_address, :explorer_token, :explorer_tx, :metamask_rpc
      )
    end
  end
end
