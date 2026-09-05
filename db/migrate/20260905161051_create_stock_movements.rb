class CreateStockMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_movements do |t|
      t.references :company, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :quantity
      t.integer :movement_type
      t.string :reference_type
      t.integer :reference_id
      t.text :notes

      t.timestamps
    end
  end
end
