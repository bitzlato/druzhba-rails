# frozen_string_literal: true

class Chain < ApplicationRecord
  validates :name, :explorer_address, :explorer_token, :explorer_tx, :metamask_rpc, presence: true
  validates :chain_id, :chain_type, presence: true

  has_many :tokens, dependent: :restrict_with_exception

  def to_s
    name
  end
end
