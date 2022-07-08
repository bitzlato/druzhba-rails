# frozen_string_literal: true

class RenameDealHistoryHashToTxHash < ActiveRecord::Migration[6.1]
  def change
    rename_column :deal_histories, :hash, :tx_hash
  end
end
