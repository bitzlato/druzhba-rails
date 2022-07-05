# frozen_string_literal: true

class Token < ApplicationRecord
  include Vault::EncryptedModel

  vault_lazy_decrypt!
  vault_attribute :signer_private_key_hex

  belongs_to :chain

  validates :name, :symbol, :address, :p2p_address, :arbiter_address, :fee, presence: true
  validates :decimals, numericality: true

  # TO-DО change to has_many
  has_one :rate, dependent: :destroy

  def arbiter
    @arbiter ||= User.find_by(eth_address: arbiter_address)
  end
end
