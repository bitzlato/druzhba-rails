# frozen_string_literal: true

module Admin
  class PaymentMethodsController < ApplicationController
    def index
      payment_methods = paginate PaymentMethod
      render locals: { payment_methods: payment_methods }
    end

    def new
      payment_method = PaymentMethod.new
      render locals: { payment_method: payment_method }
    end

    def create
      payment_method = PaymentMethod.new(payment_method_params)
      payment_method.save!
      redirect_to admin_payment_methods_path, notice: t('notices.created')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? PaymentMethod

      render :new, locals: { payment_method: payment_method }
    end

    def edit
      payment_method = PaymentMethod.find(params[:id])
      render locals: { payment_method: payment_method }
    end

    def update
      payment_method = PaymentMethod.find(params[:id])
      payment_method.update!(payment_method_params)
      redirect_to admin_payment_methods_path, notice: t('notices.updated')
    rescue ActiveRecord::RecordInvalid => e
      raise e unless e.record.is_a? PaymentMethod

      render :edit, locals: { payment_method: payment_method }
    end

    def destroy
      payment_method = PaymentMethod.find(params[:id])
      payment_method.destroy!
      redirect_back(fallback_location: admin_payment_methods_path, notice: t('notices.updated'))
    rescue ActiveRecord::DeleteRestrictionError
      redirect_back(fallback_location: admin_payment_methods_path, alert: t('alerts.destroyed'))
    end

    private

    def payment_method_params
      params.require(:payment_method).permit(:name, :active)
    end
  end
end
