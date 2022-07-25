# frozen_string_literal: true

class AddUniqueAddressToTokens < ActiveRecord::Migration[6.1]
  def change
    add_index :tokens, [:chain_id, :address], unique: true
  end
end
