class CreateSalesOrderLines < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_order_lines do |t|
      t.references :sales_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
