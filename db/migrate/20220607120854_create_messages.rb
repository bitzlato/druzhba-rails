# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :message
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :chat, null: false, foreign_key: true
      t.integer :to, null: false, default: 0

      t.timestamps
    end
  end
end
