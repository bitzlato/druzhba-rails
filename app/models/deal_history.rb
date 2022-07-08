# frozen_string_literal: true

class DealHistory < ApplicationRecord
  belongs_to :deal

  validates :state, :tx_hash, :block_number, :tx_index, :contract, :time, presence: true

  scope :ordered, -> { order(:block_number).order(:tx_index) }
end
