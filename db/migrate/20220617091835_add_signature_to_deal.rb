# frozen_string_literal: true

class AddSignatureToDeal < ActiveRecord::Migration[6.1]
  def up
    add_column :deals, :signature, :string
    execute 'UPDATE deals set signature = id'
    change_column_null :deals, :signature, false
  end

  def down
    remove_column :deals, :signature, :string
  end
end
