# frozen_string_literal: true

class AddFeeToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :fee, :integer
  end
end
