# frozen_string_literal: true

class Token < ApplicationRecord
  validates :name, :symbol, :address, :p2p_address, :arbiter_address, presence: true
  validates :chain_id, :decimals, numericality: true

  # TO-DО change to has_many
  has_one :rate, dependent: :destroy

  def arbiter
    @arbiter ||= User.find_by(eth_address: arbiter_address)
  end
end
