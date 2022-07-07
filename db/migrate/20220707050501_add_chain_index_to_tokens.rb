# frozen_string_literal: true

class AddChainIndexToTokens < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :tokens, :chains
    add_index :tokens, :chain_id
  end
end
