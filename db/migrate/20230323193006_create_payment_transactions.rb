# frozen_string_literal: true

class CreatePaymentTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_transactions do |t|
      t.references :customer, foreign_key: true, null: false
      t.references :payment, foreign_key: true, null: false
      t.references :payment_method, foreign_key: true, null: false
      t.string :revolut_payment_id, null: false
      t.timestamps null: false
    end

    add_reference :payments, :last_transaction, foreign_key: { to_table: :payment_transactions }
  end
end
