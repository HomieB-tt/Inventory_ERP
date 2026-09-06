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

ActiveRecord::Schema[8.1].define(version: 2026_09_06_100001) do
  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_companies_on_slug", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "expires_at"
    t.integer "invited_by_id", null: false
    t.integer "role", default: 0, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "email"], name: "index_invitations_on_company_id_and_email", unique: true, where: "accepted_at IS NULL"
    t.index ["company_id"], name: "index_invitations_on_company_id"
    t.index ["invited_by_id"], name: "index_invitations_on_invited_by_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "category"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "reorder_threshold", default: 0
    t.string "sku", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "sku"], name: "index_products_on_company_id_and_sku", unique: true
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "purchase_order_lines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.integer "purchase_order_id", null: false
    t.integer "quantity_ordered", null: false
    t.integer "quantity_received", default: 0, null: false
    t.decimal "unit_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_order_lines_on_product_id"
    t.index ["purchase_order_id"], name: "index_purchase_order_lines_on_purchase_order_id"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.date "expected_date"
    t.date "order_date", null: false
    t.integer "status", default: 0, null: false
    t.integer "supplier_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["company_id"], name: "index_purchase_orders_on_company_id"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
  end

  create_table "sales_order_lines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.integer "quantity", null: false
    t.integer "sales_order_id", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sales_order_lines_on_product_id"
    t.index ["sales_order_id"], name: "index_sales_order_lines_on_sales_order_id"
  end

  create_table "sales_orders", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.string "customer_name", null: false
    t.date "order_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["company_id"], name: "index_sales_orders_on_company_id"
    t.index ["user_id"], name: "index_sales_orders_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_movements", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.integer "movement_type", default: 0, null: false
    t.text "notes"
    t.integer "product_id", null: false
    t.integer "quantity", null: false
    t.integer "reference_id"
    t.string "reference_type"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "warehouse_id", null: false
    t.index ["company_id"], name: "index_stock_movements_on_company_id"
    t.index ["product_id", "warehouse_id"], name: "index_stock_movements_on_product_id_and_warehouse_id"
    t.index ["product_id"], name: "index_stock_movements_on_product_id"
    t.index ["reference_type", "reference_id"], name: "index_stock_movements_on_reference_type_and_reference_id"
    t.index ["user_id"], name: "index_stock_movements_on_user_id"
    t.index ["warehouse_id"], name: "index_stock_movements_on_warehouse_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.text "address"
    t.integer "company_id", null: false
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_suppliers_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.string "location"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "name"], name: "index_warehouses_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_warehouses_on_company_id"
  end

  add_foreign_key "invitations", "companies"
  add_foreign_key "invitations", "users", column: "invited_by_id"
  add_foreign_key "products", "companies"
  add_foreign_key "purchase_order_lines", "products"
  add_foreign_key "purchase_order_lines", "purchase_orders"
  add_foreign_key "purchase_orders", "companies"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "sales_order_lines", "products"
  add_foreign_key "sales_order_lines", "sales_orders"
  add_foreign_key "sales_orders", "companies"
  add_foreign_key "sales_orders", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "stock_movements", "companies"
  add_foreign_key "stock_movements", "products"
  add_foreign_key "stock_movements", "users"
  add_foreign_key "stock_movements", "warehouses"
  add_foreign_key "suppliers", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "warehouses", "companies"
end
