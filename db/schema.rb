# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_23_193006) do
  create_table "customers", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "revolut_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "payment_method_setups", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "revolut_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payment_method_setups_on_customer_id"
    t.index ["revolut_order_id"], name: "index_payment_method_setups_on_revolut_order_id", unique: true
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "revolut_pm_id", null: false
    t.string "card_brand", null: false
    t.string "card_last_four", null: false
    t.date "card_expired_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payment_methods_on_customer_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "payment_id", null: false
    t.integer "payment_method_id", null: false
    t.string "revolut_payment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payment_transactions_on_customer_id"
    t.index ["payment_id"], name: "index_payment_transactions_on_payment_id"
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "revolut_order_id", null: false
    t.decimal "amount", precision: 19, scale: 2, null: false
    t.integer "status_id", limit: 2, null: false
    t.boolean "force_three_ds", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_transaction_id"
    t.index ["customer_id"], name: "index_payments_on_customer_id"
    t.index ["last_transaction_id"], name: "index_payments_on_last_transaction_id"
  end

  add_foreign_key "payment_method_setups", "customers"
  add_foreign_key "payment_methods", "customers"
  add_foreign_key "payment_transactions", "customers"
  add_foreign_key "payment_transactions", "payment_methods"
  add_foreign_key "payment_transactions", "payments"
  add_foreign_key "payments", "customers"
  add_foreign_key "payments", "payment_transactions", column: "last_transaction_id"
end
