# frozen_string_literal: true

class AddSignerFieldsToTokens < ActiveRecord::Migration[6.1]
  def change
    change_table :tokens, bulk: true do |t|
      t.string :signer_address
      t.string :signer_private_key_hex_encrypted
    end
  end
end
