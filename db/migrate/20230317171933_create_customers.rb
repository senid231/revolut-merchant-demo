# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :revolut_customer_id
      t.timestamps null: false
    end

    add_index :customers, :email, unique: true
  end
end
