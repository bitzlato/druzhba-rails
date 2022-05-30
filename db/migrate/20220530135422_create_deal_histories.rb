class CreateDealHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :deal_histories do |t|
      t.references :deal, null: false, foreign_key: true
      t.integer :state, null: false
      t.string :hash, null: false
      t.datetime :time, null: false

      t.timestamps
    end
  end
end
