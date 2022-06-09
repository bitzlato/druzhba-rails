# frozen_string_literal: true

# Создает сообщение в чате с файлом
# Если чат сделки еще не существует - создает и его

class MessageFileBuilder < MessageBuilder
  attr_reader :deal, :file, :name, :author, :to

  def initialize(deal:, file:, name:, author:, to: :both)
    @deal = deal
    @file = file
    @name = name
    @author = author
    @to = to
  end

  private

  def build_message
    Message.new(file: file, file_title: name, author: author, to: validated_to)
  end
end
