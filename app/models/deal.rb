# frozen_string_literal: true

class Deal < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  belongs_to :offer

  has_one :chat, dependent: :destroy
  has_many :deal_histories, dependent: :delete_all

  validates :fee, :locked, :internal_id, numericality: true
  validates :signature, :deadline_at, presence: true

  scope :active, -> { where('deadline_at > ?', Time.current).where(state: :draft) }

  enum state: {
    draft: 0,
    started: 1,
    payment_complete: 2,
    dispute: 3,
    canceled_arbiter: 4,
    canceled_timeout_arbiter: 5,
    canceled_buyer: 6,
    canceled_seller: 7,
    cleared_seller: 8,
    cleared_arbiter: 9
  }, _default: :draft

  def chat_members
    [seller, buyer, offer.arbiter].compact
  end

  def self.chat_identifier_for(deal_id, user)
    "deal_#{deal_id}_chat_for_#{user.uid}"
  end

  def update_state_from_history!
    deal_history = deal_histories.order(:block_number).order(:tx_index).last
    update!({ state: deal_history.state })
  end
end
