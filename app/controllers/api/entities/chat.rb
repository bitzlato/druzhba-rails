# frozen_string_literal: true

module Api
  module Entities
    class Chat < Grape::Entity
      expose :data, documentation: { type: Array, desc: 'Array of messages' },
                    using: Api::Entities::Message, &:messages

      expose :total, documentation: { type: Integer, desc: 'Total pages count' } do |chat_bilder|
        chat_bilder.messages.total_pages
      end
    end
  end
end
