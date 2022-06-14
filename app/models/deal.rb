# frozen_string_literal: true

class Deal < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  belongs_to :offer

  has_one :chat, dependent: :destroy

  validates :fee, :locked, numericality: true

  enum state: {
    initial: 0,
    started: 1,
    payment_complete: 2,
    dispute: 3,
    canceled_arbiter: 4,
    canceled_timeout_arbiter: 5,
    canceled_buyer: 6,
    canceled_seller: 7,
    cleared_seller: 8,
    cleared_arbiter: 9
  }

  def chat_members
    [seller, buyer, offer.arbiter].compact
  end

  def self.chat_identifier_for(deal_id, user)
    "deal_#{deal_id}_chat_for_#{user.uid}"
  end
end
