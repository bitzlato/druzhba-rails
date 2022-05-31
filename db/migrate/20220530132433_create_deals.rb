# frozen_string_literal: true

class CreateDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :deals do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.references :buyer, null: false, foreign_key: { to_table: :users }
      t.references :offer, null: false, foreign_key: true
      t.integer :fee, null: false
      t.integer :locked, null: false
      t.integer :state, default: 0, null: false
      t.boolean :in_use, default: true

      t.timestamps
    end
  end
end
