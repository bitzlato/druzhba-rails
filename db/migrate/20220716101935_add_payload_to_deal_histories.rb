# frozen_string_literal: true

class AddPayloadToDealHistories < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def change
    add_column :deal_histories, :payload, :jsonb, null: false, default: {}
    remove_column :deal_histories, :time, :datetime, null: false
    remove_column :deal_histories, :contract, :string, null: false
  end
  # rubocop:enable Rails/BulkChangeTable
end
