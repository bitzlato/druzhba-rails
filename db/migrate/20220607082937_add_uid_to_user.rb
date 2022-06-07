# frozen_string_literal: true

class AddUidToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string, null: false, default: ''
    add_index :users, :uid, unique: true
  end
end
