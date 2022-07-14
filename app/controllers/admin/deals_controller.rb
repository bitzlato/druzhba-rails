# frozen_string_literal: true

module Admin
  class DealsController < ApplicationController
    def index
      deals = paginate Deal
      render locals: { deals: deals }
    end
  end
end
