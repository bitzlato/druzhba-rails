# frozen_string_literal: true

class Rate < ApplicationRecord
  belongs_to :token
  belongs_to :currency

  validates :rate, presence: true
end
