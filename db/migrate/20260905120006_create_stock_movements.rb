class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.references :company, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :movement_type, null: false, default: 0
      t.string :reference_type
      t.integer :reference_id
      t.text :notes

      t.timestamps
    end
    add_index :stock_movements, [:product_id, :warehouse_id]
    add_index :stock_movements, [:reference_type, :reference_id]
  end
end
