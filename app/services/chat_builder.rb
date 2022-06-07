# frozen_string_literal: true

# Фильтрует сообщения для пользователя в чате сделки
# Арбитер видит все сообщения участников между собой и свои с участником по arbiter_filter
# Seller видит свои сообщения, сообщения byuer и арбитра
# Byuer видит свои сообщения, сообщения seller и арбитра

class ChatBuilder
  attr_reader :deal, :user, :limit, :page, :arbiter_filter

  def initialize(deal, user, filter_params)
    @deal = deal
    @user = user
    @limit = filter_params[:limit].to_i
    @page = filter_params[:page].to_i
    @arbiter_filter = filter_params[:with]
  end

  def messages
    @messages ||= filtered_messages.order(created_at: :desc).page(page).per(limit)
  end

  private

  # rubocop:disable Metrics/AbcSize
  def filtered_messages
    return [] if chat.blank?

    return chat.messages.where(to: [:both, arbiter_filter]) if user.arbiter_of?(deal)
    return chat.messages.for_buyer if user.buyer_of?(deal)
    return chat.messages.for_seller if user.seller_of?(deal)
  end
  # rubocop:enable Metrics/AbcSize

  def chat
    @chat ||= deal.chat
  end
end
