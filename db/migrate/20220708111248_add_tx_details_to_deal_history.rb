# frozen_string_literal: true

class AddTxDetailsToDealHistory < ActiveRecord::Migration[6.1]
  def change
    change_table :deal_histories, bulk: true do |t|
      t.bigint :block_number, null: false
      t.bigint :tx_index, null: false
      t.string :contract, null: false
    end
  end
end
