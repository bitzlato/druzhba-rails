# frozen_string_literal: true

module Admin
  class DealsController < Admin::ApplicationController
    def index
      deals = paginate Deal
      render locals: { deals: deals }
    end
  end
end
