class CreatePurchaseOrderLines < ActiveRecord::Migration[8.1]
  def change
    create_table :purchase_order_lines do |t|
      t.references :purchase_order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity_ordered
      t.integer :quantity_received
      t.decimal :unit_cost

      t.timestamps
    end
  end
end
