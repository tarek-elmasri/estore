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

ActiveRecord::Schema.define(version: 2022_07_12_194301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authorizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "collection"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.uuid "order_item_id"
    t.uuid "item_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_cards_on_item_id"
    t.index ["order_item_id"], name: "index_cards_on_order_item_id"
  end

  create_table "cart_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cart_id", null: false
    t.uuid "item_id", null: false
    t.integer "quantity", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["item_id"], name: "index_cart_items_on_item_id"
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "primary_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "pinned", default: false
    t.index ["primary_category_id"], name: "index_categories_on_primary_category_id"
  end

  create_table "coupons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.integer "amount"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "item_id", null: false
    t.uuid "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_item_categories_on_category_id"
    t.index ["item_id"], name: "index_item_categories_on_item_id"
  end

  create_table "item_stocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "active", default: 0, null: false
    t.integer "pending", default: 0, null: false
    t.integer "sales", default: 0, null: false
    t.uuid "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "low_stock", default: 0
    t.boolean "notify_on_low_stock", default: false
    t.boolean "has_limited_stock", default: false
    t.index ["item_id"], name: "index_item_stocks_on_item_id"
  end

  create_table "items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type_name", null: false
    t.string "name", null: false
    t.float "price", null: false
    t.boolean "has_limited_stock", default: true, null: false
    t.integer "stock"
    t.integer "low_stock"
    t.boolean "notify_on_low_stock", default: false
    t.boolean "visible", default: false
    t.string "code"
    t.float "cost"
    t.float "discount_price"
    t.boolean "has_discount", default: false
    t.datetime "discount_end_date"
    t.datetime "discount_start_date"
    t.boolean "limited_quantity_per_customer", default: false
    t.integer "max_quantity_per_customer"
    t.boolean "allow_multi_quantity", default: false
    t.boolean "allow_duplicate", default: false
    t.string "title"
    t.string "sub_title"
    t.string "hint"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "available", default: false
    t.boolean "pinned", default: false
  end

  create_table "order_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.integer "quantity", null: false
    t.float "value", null: false
    t.float "t_value", null: false
    t.string "description", null: false
    t.uuid "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "delivery_status", default: "pending", null: false
    t.string "type_name", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.float "t_value", null: false
    t.float "t_vat", null: false
    t.string "status", default: "established", null: false
    t.string "payment_intent"
    t.float "t_payment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "delivery_status", default: "pending", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "version", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "staff_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "action", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "model", null: false
    t.string "model_id", null: false
    t.index ["user_id"], name: "index_staff_actions_on_user_id"
  end

  create_table "user_coupons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "coupon_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coupon_id"], name: "index_user_coupons_on_coupon_id"
    t.index ["user_id"], name: "index_user_coupons_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_no", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "rule", default: "user"
    t.string "gender", null: false
    t.string "refresh_token"
    t.date "dob"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "active", null: false
    t.string "forget_password_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["forget_password_token"], name: "index_users_on_forget_password_token", unique: true
    t.index ["phone_no"], name: "index_users_on_phone_no", unique: true
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "cards", "items"
  add_foreign_key "cards", "order_items"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "items"
  add_foreign_key "carts", "users"
  add_foreign_key "item_categories", "categories"
  add_foreign_key "item_categories", "items"
  add_foreign_key "item_stocks", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "staff_actions", "users"
  add_foreign_key "user_coupons", "coupons"
  add_foreign_key "user_coupons", "users"
end
