class CreateStockTransfers < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_transfers do |t|
      t.references :company, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :from_warehouse, null: false, foreign_key: { to_table: :warehouses }
      t.references :to_warehouse, null: false, foreign_key: { to_table: :warehouses }
      t.references :user, null: false, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
