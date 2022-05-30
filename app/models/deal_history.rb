class DealHistory < ApplicationRecord
  belongs_to :deal

  validates :state, :hash, :time, presence: true
end
