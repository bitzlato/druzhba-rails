# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations, Rails/BulkChangeTable
class AddBlockchainDetailsToChains < ActiveRecord::Migration[6.1]
  def change
    add_column :chains, :chain_id, :integer
    add_column :chains, :chain_type, :string
    Chain.update_all(chain_id: 1, chain_type: 'ETH')
    change_column_null :chains, :chain_id, false
    change_column_null :chains, :chain_type, false
  end
end
# rubocop:enable Rails/SkipsModelValidations, Rails/BulkChangeTable
