# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Flashes
  include RescueErrors
end
