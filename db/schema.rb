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

ActiveRecord::Schema.define(version: 2022_05_30_135422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "token_id", null: false
    t.bigint "locked", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token_id"], name: "index_balances_on_token_id"
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.string "logo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deal_histories", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.integer "state", null: false
    t.string "hash", null: false
    t.datetime "time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deal_id"], name: "index_deal_histories_on_deal_id"
  end

  create_table "deals", force: :cascade do |t|
    t.bigint "seller_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "offer_id", null: false
    t.integer "fee", null: false
    t.integer "locked", null: false
    t.integer "state", default: 0, null: false
    t.boolean "in_use", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_deals_on_buyer_id"
    t.index ["offer_id"], name: "index_deals_on_offer_id"
    t.index ["seller_id"], name: "index_deals_on_seller_id"
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "token_id", null: false
    t.bigint "currency_id", null: false
    t.bigint "payment_method_id", null: false
    t.bigint "balance_id", null: false
    t.decimal "rate", null: false
    t.decimal "min", null: false
    t.decimal "max", null: false
    t.text "terms"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["balance_id"], name: "index_offers_on_balance_id"
    t.index ["currency_id"], name: "index_offers_on_currency_id"
    t.index ["payment_method_id"], name: "index_offers_on_payment_method_id"
    t.index ["token_id"], name: "index_offers_on_token_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string "address", null: false
    t.bigint "chain_id", null: false
    t.integer "decimals", null: false
    t.string "p2p_address", null: false
    t.string "arbiter_address", null: false
    t.string "name", null: false
    t.string "symbol", null: false
    t.string "logo", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "eth_address", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "balances", "tokens"
  add_foreign_key "balances", "users"
  add_foreign_key "deal_histories", "deals"
  add_foreign_key "deals", "offers"
  add_foreign_key "deals", "users", column: "buyer_id"
  add_foreign_key "deals", "users", column: "seller_id"
  add_foreign_key "offers", "balances"
  add_foreign_key "offers", "currencies"
  add_foreign_key "offers", "payment_methods"
  add_foreign_key "offers", "tokens"
  add_foreign_key "offers", "users"
end