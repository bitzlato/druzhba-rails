# frozen_string_literal: true

class RemoveInUseFromDeals < ActiveRecord::Migration[6.1]
  def change
    remove_column :deals, :in_use, :boolean, default: true
  end
end
