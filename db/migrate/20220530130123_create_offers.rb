class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :token, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :balance, null: false, foreign_key: true
      t.decimal :rate, null: false
      t.decimal :min, null: false
      t.decimal :max, null: false
      t.text :terms
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
