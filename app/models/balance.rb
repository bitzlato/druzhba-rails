# frozen_string_literal: true

class Balance < ApplicationRecord
  belongs_to :user
  belongs_to :token

  validates :locked, numericality: true
end
