# frozen_string_literal: true

class CreateBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :balances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :token, null: false, foreign_key: true
      t.integer :locked, limit: 8, null: false, default: 0

      t.timestamps
    end
  end
end
