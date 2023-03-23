# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :customer, foreign_key: true, null: false
      t.string :revolut_order_id, null: false
      t.decimal :amount, null: false, precision: 19, scale: 2
      t.integer :status_id, null: false, limit: 2
      t.boolean :force_three_ds, default: false, null: false
      t.timestamps null: false
    end
  end
end
