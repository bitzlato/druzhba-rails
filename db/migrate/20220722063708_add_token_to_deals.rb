# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
class AddTokenToDeals < ActiveRecord::Migration[6.1]
  def change
    add_column :deals, :token_id, :bigint

    Deal.find_each do |deal|
      deal.update_column(:token_id, deal.offer.token_id)
    end

    change_column_null :deals, :token_id, false
    add_foreign_key :deals, :tokens
    add_index :deals, :token_id
  end
end
# rubocop:enable Rails/SkipsModelValidations
