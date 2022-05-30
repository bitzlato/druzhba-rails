# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :address, null: false
      t.bigint :chain_id, null: false
      t.integer :decimals, null: false
      t.string :p2p_address, null: false
      t.string :arbiter_address, null: false
      t.string :name, null: false
      t.string :symbol, null: false
      t.string :logo, null: false

      t.timestamps
    end
  end
end
