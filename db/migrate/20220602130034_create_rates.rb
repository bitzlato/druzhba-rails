# frozen_string_literal: true

class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.references :token, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true
      t.decimal :rate, null: false

      t.timestamps
    end
  end
end
