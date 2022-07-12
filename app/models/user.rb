# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :messages, foreign_key: :author_id, dependent: :destroy, inverse_of: :author

  validates :eth_address, presence: true

  def member_of?(deal)
    buyer_of?(deal) || seller_of?(deal) || arbiter_of?(deal)
  end

  def buyer_of?(deal)
    deal.buyer_id == id
  end

  def seller_of?(deal)
    deal.seller_id == id
  end

  def arbiter_of?(deal)
    deal.offer.arbiter == self
  end

  def to_s
    eth_address
  end
end
