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

ActiveRecord::Schema[8.1].define(version: 2026_10_20_052803) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.hypopg"
  enable_extension "extensions.index_advisor"
  enable_extension "extensions.pg_net"
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "extensions.wrappers"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.pg_cron"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgmq.pgmq"
  enable_extension "vault.supabase_vault"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "public.color_source", ["99COLORS_NET", "ART_PAINTS_YG07S", "BYRNE", "CRAYOLA", "CMYK_COLOR_MODEL", "COLORCODE_IS", "COLORHEXA", "COLORXS", "CORNELL_UNIVERSITY", "COLUMBIA_UNIVERSITY", "DUKE_UNIVERSITY", "ENCYCOLORPEDIA_COM", "ETON_COLLEGE", "FANTETTI_AND_PETRACCHI", "FINDTHEDATA_COM", "FERRARIO_1919", "FEDERAL_STANDARD_595", "FLAG_OF_INDIA", "FLAG_OF_SOUTH_AFRICA", "GLAZEBROOK_AND_BALDRY", "GOOGLE", "HEXCOLOR_CO", "ISCC_NBS", "KELLY_MOORE", "MATTEL", "MAERZ_AND_PAUL", "MILK_PAINT", "MUNSELL_COLOR_WHEEL", "NATURAL_COLOR_SYSTEM", "PANTONE", "PLOCHERE", "POURPRE_COM", "RAL", "RESENE", "RGB_COLOR_MODEL", "THOM_POOLE", "UNIVERSITY_OF_ALABAMA", "UNIVERSITY_OF_CALIFORNIA_DAVIS", "UNIVERSITY_OF_CAMBRIDGE", "UNIVERSITY_OF_NORTH_CAROLINA", "UNIVERSITY_OF_TEXAS_AT_AUSTIN", "X11_WEB", "XONA_COM"]

  create_table "public.customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.string "company_name"
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "public.items", force: :cascade do |t|
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

  create_table "public.line_items", force: :cascade do |t|
    t.integer "quote_id"
    t.integer "item_id"
    t.integer "quantity", default: 1
    t.integer "unit_price_cents", default: 0, null: false
    t.string "unit_price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_line_items_on_item_id"
    t.index ["quote_id"], name: "index_line_items_on_quote_id"
  end

  create_table "public.pay_charges", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "public.pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["owner_type", "owner_id", "deleted_at"], name: "pay_customer_owner_index", unique: true
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "public.pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "public.pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "payment_method_type"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "public.pay_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "current_period_start", precision: nil
    t.datetime "current_period_end", precision: nil
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at", precision: nil
    t.datetime "pause_resumes_at", precision: nil
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.string "stripe_account"
    t.string "payment_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "public.pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "draft", null: false
    t.integer "customer_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "public.quotes", force: :cascade do |t|
    t.string "quote_number"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "status"
    t.string "stripe_quote_id"
    t.index ["customer_id"], name: "index_quotes_on_customer_id"
    t.index ["quote_number"], name: "index_quotes_on_quote_number", unique: true
  end

  create_table "public.solid_queue_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.users", force: :cascade do |t|
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

  create_table "public.wikis", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wikis_on_user_id"
  end

  add_foreign_key "public.line_items", "public.items"
  add_foreign_key "public.line_items", "public.quotes"
  add_foreign_key "public.pay_charges", "public.pay_customers", column: "customer_id"
  add_foreign_key "public.pay_charges", "public.pay_subscriptions", column: "subscription_id"
  add_foreign_key "public.pay_payment_methods", "public.pay_customers", column: "customer_id"
  add_foreign_key "public.pay_subscriptions", "public.pay_customers", column: "customer_id"
  add_foreign_key "public.projects", "public.customers"
  add_foreign_key "public.projects", "public.users"
  add_foreign_key "public.quotes", "public.customers"
  add_foreign_key "public.wikis", "public.users"

  create_table "extensions.wrappers_fdw_stats", primary_key: "fdw_name", id: :text, comment: "Wrappers Foreign Data Wrapper statistics", force: :cascade do |t|
    t.bigint "create_times", comment: "Total number of times the FDW instacne has been created"
    t.bigint "rows_in", comment: "Total rows input from origin"
    t.bigint "rows_out", comment: "Total rows output to Postgres"
    t.bigint "bytes_in", comment: "Total bytes input from origin"
    t.bigint "bytes_out", comment: "Total bytes output to Postgres"
    t.jsonb "metadata", comment: "Metadata specific for the FDW"
    t.timestamptz "created_at", default: -> { "timezone('utc'::text, now())" }, null: false
    t.timestamptz "updated_at", default: -> { "timezone('utc'::text, now())" }, null: false
  end
end
