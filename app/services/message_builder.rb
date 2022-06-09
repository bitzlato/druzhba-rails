# frozen_string_literal: true

# Создает сообщения в чате сделки из параметров api
# Если чат сделки еще не существует - создает и его

class MessageBuilder
  attr_reader :deal, :message, :author, :to, :new_message

  def initialize(deal:, message:, author:, to: :both)
    @deal = deal
    @message = message
    @author = author
    @to = to
  end

  def save
    @new_message = build_message
    Message.transaction do
      @new_message.chat = Chat.where(deal: deal).first_or_create!
      @new_message.save
    end
    broadcast_new_message if new_message.persisted?
  end

  private

  def build_message
    Message.new(message: message, author: author, to: validated_to)
  end

  # seller или buyer могут отправлять только c типом `both` или `arbiter`
  def validated_to
    to.to_sym.in?([:seller, :buyer]) && !author.arbiter_of?(deal) ? :both : to
  end

  def broadcast_new_message
    deal.chat_members.each do |chat_member|
      next if chat_member == author
      next unless new_message.available_for?(chat_member)

      ActionCable.server.broadcast Deal.chat_identifier_for(deal.id, chat_member),
                                   Api::Entities::Message.represent(new_message, requester: chat_member)
    end
  end
end
