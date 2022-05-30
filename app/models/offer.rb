class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :token
  belongs_to :currency
  belongs_to :payment_method
  belongs_to :balance

  validates :rate, :min, :max, numericality: true
end
