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

ActiveRecord::Schema.define(version: 2022_07_16_101935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "token_id", null: false
    t.bigint "locked", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token_id"], name: "index_balances_on_token_id"
    t.index ["user_id"], name: "index_balances_on_user_id"
  end

  create_table "chains", force: :cascade do |t|
    t.string "name", null: false
    t.string "explorer_address", null: false
    t.string "explorer_token", null: false
    t.string "explorer_tx", null: false
    t.string "metamask_rpc", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "deal_id"
    t.string "status", default: "initial", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deal_id"], name: "index_chats_on_deal_id"
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
    t.string "tx_hash", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "block_number", null: false
    t.bigint "tx_index", null: false
    t.jsonb "payload", default: {}, null: false
    t.index ["deal_id"], name: "index_deal_histories_on_deal_id"
  end

  create_table "deals", force: :cascade do |t|
    t.bigint "seller_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "offer_id", null: false
    t.integer "fee", null: false
    t.integer "locked", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deadline_at", null: false
    t.integer "internal_id", null: false
    t.string "signature", null: false
    t.index ["buyer_id"], name: "index_deals_on_buyer_id"
    t.index ["offer_id"], name: "index_deals_on_offer_id"
    t.index ["seller_id"], name: "index_deals_on_seller_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "message"
    t.bigint "author_id", null: false
    t.bigint "chat_id", null: false
    t.integer "to", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "file"
    t.string "file_title"
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
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

  create_table "rates", force: :cascade do |t|
    t.bigint "token_id", null: false
    t.bigint "currency_id", null: false
    t.decimal "rate", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_rates_on_currency_id"
    t.index ["token_id"], name: "index_rates_on_token_id"
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
    t.string "signer_address"
    t.string "signer_private_key_hex_encrypted"
    t.integer "fee"
    t.index ["chain_id"], name: "index_tokens_on_chain_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "eth_address", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid", default: "", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "balances", "tokens"
  add_foreign_key "balances", "users"
  add_foreign_key "deal_histories", "deals"
  add_foreign_key "deals", "offers"
  add_foreign_key "deals", "users", column: "buyer_id"
  add_foreign_key "deals", "users", column: "seller_id"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "offers", "balances"
  add_foreign_key "offers", "currencies"
  add_foreign_key "offers", "payment_methods"
  add_foreign_key "offers", "tokens"
  add_foreign_key "offers", "users"
  add_foreign_key "rates", "currencies"
  add_foreign_key "rates", "tokens"
  add_foreign_key "tokens", "chains"
end
