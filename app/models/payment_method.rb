# frozen_string_literal: true

class PaymentMethod < ApplicationRecord
  validates :name, presence: true
  scope :active, -> { where(active: true) }

  has_many :offers, dependent: :restrict_with_exception

  def to_s
    name
  end
end
