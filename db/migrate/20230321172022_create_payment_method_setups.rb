# frozen_string_literal: true

class CreatePaymentMethodSetups < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_method_setups do |t|
      t.references :customer, foreign_key: true, null: false
      t.string :revolut_order_id, null: false
      t.timestamps null: false
    end

    add_index :payment_method_setups, :revolut_order_id, unique: true
  end
end
