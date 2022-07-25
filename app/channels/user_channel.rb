# frozen_string_literal: true

class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_user
  end

  def unsubscribed; end
end
