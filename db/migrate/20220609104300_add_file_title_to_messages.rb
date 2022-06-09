# frozen_string_literal: true

class AddFileTitleToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :file_title, :string
  end
end
