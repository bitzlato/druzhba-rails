# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from Deal.chat_identifier_for(params[:deal_id], current_user)
  end

  def unsubscribed; end
end
