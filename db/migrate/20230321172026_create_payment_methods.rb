# frozen_string_literal: true

class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.references :customer, foreign_key: true, null: false
      t.string :revolut_pm_id, null: false
      t.string :card_brand, null: false
      t.string :card_last_four, null: false
      t.date :card_expired_at, null: false
      t.timestamps null: false
    end
  end
end
