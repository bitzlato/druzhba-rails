# frozen_string_literal: true

module Api
  module Entities
    class MessageFile < Grape::Entity
      expose :title, documentation: { type: String, desc: 'File title' } do |file|
        file.model.file_title
      end
      expose :url, documentation: { type: String, desc: 'File url' }
    end
  end
end
