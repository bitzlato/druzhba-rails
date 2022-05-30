# frozen_string_literal: true

class Currency < ApplicationRecord
  validates :name, :symbol, presence: true
end
