class Deal < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User'
  belongs_to :offer

  validates :fee, :locked, numericality: true

  enum state: { initial: 0 }
end
