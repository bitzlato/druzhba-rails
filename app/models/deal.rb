# frozen_string_literal: true

class Deal < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  belongs_to :offer

  has_one :chat, dependent: :destroy

  validates :fee, :locked, numericality: true

  enum state: { initial: 0, prepared: 1 }

  def chat_members
    [seller, buyer, offer.arbiter].compact
  end

  def self.chat_identifier_for(deal_id, user)
    "deal_#{deal_id}_chat_for_#{user.uid}"
  end
end
