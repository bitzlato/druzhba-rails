# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[6.1]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.string :logo

      t.timestamps
    end
  end
end
