class Token < ApplicationRecord
  validates :name, :symbol, :address, :p2p_address, :arbiter_address, presence: true
  validates :chain_id, :decimals, numericality: true
end
