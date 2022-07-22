# frozen_string_literal: true

class Deal < ApplicationRecord
  DEADLINE_FINISH_DELAY = 10
  FINISHED_STATES = [
    :canceled_timeout_arbiter, :canceled_buyer, :cleared_seller, :canceled_arbiter, :cleared_arbiter
  ].freeze
  STATES = {
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
  }.freeze

  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  belongs_to :offer
  belongs_to :token

  has_one :chat, dependent: :destroy
  has_many :deal_histories, dependent: :delete_all

  validates :fee, :locked, :internal_id, numericality: true
  validates :signature, :deadline_at, presence: true
  validate :internal_id_is_unique_for_status

  scope :active_draft, -> { where('deadline_at > ?', Time.current).where(state: :draft) }
  scope :not_finished, -> { where(finished: false) }
  scope :draft_to_finish, -> { where('deadline_at < ?', DEADLINE_FINISH_DELAY.minutes.before).where(state: :draft) }

  enum state: STATES, _default: :draft

  def deal_members
    [seller, buyer, offer.arbiter].compact
  end

  def self.chat_identifier_for(deal_id, user)
    "deal_#{deal_id}_chat_for_#{user.uid}"
  end

  def update_state_from_history!
    deal_history = deal_histories.order(:block_number).order(:tx_index).last
    new_deal_state = STATES.key(deal_history.state)
    update!({ state: new_deal_state, finished: FINISHED_STATES.include?(new_deal_state) })
  end

  private

  def internal_id_is_unique_for_status
    same_internal_id_deals = self.class.not_finished.where.not(id: id).where(internal_id: internal_id)
    errors.add(:internal_id, 'is not unique') if !finished && same_internal_id_deals.any?
  end
end
