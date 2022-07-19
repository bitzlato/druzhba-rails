# frozen_string_literal: true

class AddActiveToPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :payment_methods, :active, :boolean, null: false, default: true
  end
end
