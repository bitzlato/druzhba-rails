# frozen_string_literal: true

class AddFinishedToDeals < ActiveRecord::Migration[6.1]
  def change
    add_column :deals, :finished, :boolean, null: false, default: false
    add_index :deals, [:token_id, :internal_id], where: 'finished = false', unique: true

    add_index :deals, :finished
  end
end
