# frozen_string_literal: true

class AddSignerPrivateKeyHexToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :signer_private_key_hex, :string
  end
end
