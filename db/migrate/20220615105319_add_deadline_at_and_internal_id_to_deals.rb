# frozen_string_literal: true

class AddDeadlineAtAndInternalIdToDeals < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def up
    add_column :deals, :deadline_at, :timestamp
    add_column :deals, :internal_id, :integer

    execute "UPDATE deals set deadline_at = created_at + (10 * interval '1 minute')"
    execute 'UPDATE deals set internal_id = id'

    change_column_null :deals, :deadline_at, false
    change_column_null :deals, :internal_id, false
  end

  def down
    remove_column :deals, :deadline_at
    remove_column :deals, :internal_id
  end
  # rubocop:enable Rails/BulkChangeTable
end
