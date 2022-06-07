# frozen_string_literal: true

module Api
  module Entities
    class Message < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'Unique deal identifier in database' }
      expose :message, documentation: { type: String, desc: 'Text of message' }
      expose :created_at, documentation: { type: Integer, desc: 'Timestamp of message created time' } do |message|
        message.created_at.to_i
      end
      expose :author_id, documentation: { type: Integer, desc: 'Unique author of message identifier' }
      expose :type, documentation: { type: String, desc: 'Type of message (In|Out)' } do |message, options|
        message.author_id == options[:requester].id ? 'Out' : 'In'
      end
    end
  end
end
