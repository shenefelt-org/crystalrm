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

ActiveRecord::Schema[8.1].define(version: 2026_10_14_191259) do
  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.boolean "active", default: true, null: false
    t.string "recurring_interval"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_price_id"], name: "index_items_on_stripe_price_id", unique: true
    t.index ["stripe_product_id"], name: "index_items_on_stripe_product_id", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "item_id", null: false
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_line_items_on_item_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "customer_id", null: false
    t.string "order_number"
    t.string "status", default: "pending", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "description"
    t.string "access_token"
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_orders_on_access_token", unique: true
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["project_id"], name: "index_orders_on_project_id"
    t.index ["stripe_checkout_session_id"], name: "index_orders_on_stripe_checkout_session_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "draft", null: false
    t.string "stripe_checkout_session_id"
    t.integer "customer_id", null: false
    t.integer "user_id", null: false
    t.integer "project_value_cents", default: 0, null: false
    t.string "project_value_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wikis", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wikis_on_user_id"
  end

  add_foreign_key "line_items", "items"
  add_foreign_key "line_items", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "projects"
  add_foreign_key "projects", "customers"
  add_foreign_key "projects", "users"
  add_foreign_key "wikis", "users"
end
