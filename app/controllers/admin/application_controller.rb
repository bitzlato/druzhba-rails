# frozen_string_literal: true

module Admin
  class ApplicationController < ApplicationController
    layout 'fluid'

    include UserAuthSupport
    include PaginationSupport
  end
end
