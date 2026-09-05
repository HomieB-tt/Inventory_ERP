class CreatePurchaseOrderLines < ActiveRecord::Migration[8.0]
  def change
    create_table :purchase_order_lines do |t|
      t.references :purchase_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity_ordered, null: false
      t.integer :quantity_received, null: false, default: 0
      t.decimal :unit_cost, precision: 10, scale: 2, null: false, default: 0

      t.timestamps
    end
  end
end
