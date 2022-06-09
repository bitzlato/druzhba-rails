# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :chat

  enum to: { both: 0, seller: 1, buyer: 2, arbiter: 3 }

  mount_uploader :file, MessageFileUploader

  validates :message, presence: true, if: -> { file.blank? }
  validates :file, :file_title, presence: true, if: -> { message.blank? }

  scope :for_buyer, -> { where(to: [:both, :buyer, :arbiter]) }
  scope :for_seller, -> { where(to: [:both, :seller, :arbiter]) }
end
