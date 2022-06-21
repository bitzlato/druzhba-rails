# frozen_string_literal: true

class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :token
  belongs_to :currency
  belongs_to :payment_method
  belongs_to :balance

  validates :rate, :min, :max, numericality: true

  delegate :arbiter, to: :token

  before_validation :set_balance, on: :create

  private

  def set_balance
    return if user_id.blank? || token_id.blank?

    self.balance = Balance.find_by(token_id: token_id, user_id: user_id)
  end
end
