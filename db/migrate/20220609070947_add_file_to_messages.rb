# frozen_string_literal: true

class AddFileToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :file, :string
  end
end
