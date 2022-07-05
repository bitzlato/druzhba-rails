# frozen_string_literal: true

class CreateChains < ActiveRecord::Migration[6.1]
  def change
    create_table :chains do |t|
      t.string :name, null: false
      t.string :explorer_address, null: false
      t.string :explorer_token, null: false
      t.string :explorer_tx, null: false
      t.string :metamask_rpc, null: false

      t.timestamps
    end
  end
end
