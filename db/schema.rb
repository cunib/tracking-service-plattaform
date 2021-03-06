# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171004222322) do

  create_table "businesses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "position_id"
    t.string   "path_strategy"
    t.index ["position_id"], name: "index_businesses_on_position_id", using: :btree
  end

  create_table "deliveries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "delivery_man_id"
    t.string   "path_strategy"
    t.integer  "business_id"
    t.index ["business_id"], name: "index_deliveries_on_business_id", using: :btree
    t.index ["delivery_man_id"], name: "index_deliveries_on_delivery_man_id", using: :btree
  end

  create_table "delivery_men", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "nickname"
    t.integer "business_id"
    t.integer "trace_id"
    t.index ["business_id"], name: "index_delivery_men_on_business_id", using: :btree
    t.index ["trace_id"], name: "index_delivery_men_on_trace_id", using: :btree
  end

  create_table "ordered_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.float   "amount",     limit: 24
    t.index ["order_id"], name: "index_ordered_products_on_order_id", using: :btree
    t.index ["product_id"], name: "index_ordered_products_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "address"
    t.integer  "business_id"
    t.integer  "delivery_id"
    t.integer  "status",             default: 0, null: false
    t.integer  "position_id"
    t.string   "hash_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_full_name"
    t.string   "customer_email"
    t.index ["business_id"], name: "index_orders_on_business_id", using: :btree
    t.index ["delivery_id"], name: "index_orders_on_delivery_id", using: :btree
    t.index ["position_id"], name: "index_orders_on_position_id", using: :btree
  end

  create_table "paths", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position_id"
    t.index ["delivery_id"], name: "index_paths_on_delivery_id", using: :btree
    t.index ["position_id"], name: "index_paths_on_position_id", using: :btree
  end

  create_table "positions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                 null: false
    t.string   "description"
    t.float    "price",       limit: 24, default: 0.0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "business_id"
    t.index ["business_id"], name: "index_products_on_business_id", using: :btree
  end

  create_table "traces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "date"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position_id"
    t.index ["delivery_id"], name: "index_traces_on_delivery_id", using: :btree
    t.index ["position_id"], name: "index_traces_on_position_id", using: :btree
  end

  add_foreign_key "businesses", "positions"
  add_foreign_key "deliveries", "businesses"
  add_foreign_key "deliveries", "delivery_men"
  add_foreign_key "delivery_men", "businesses"
  add_foreign_key "delivery_men", "traces"
  add_foreign_key "ordered_products", "orders"
  add_foreign_key "ordered_products", "products"
  add_foreign_key "orders", "businesses"
  add_foreign_key "orders", "deliveries"
  add_foreign_key "orders", "positions"
  add_foreign_key "paths", "deliveries"
  add_foreign_key "paths", "positions"
  add_foreign_key "products", "businesses"
  add_foreign_key "traces", "deliveries"
  add_foreign_key "traces", "positions"
end
