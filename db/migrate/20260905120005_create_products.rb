class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :company, null: false, foreign_key: true
      t.string :sku, null: false
      t.string :name, null: false
      t.text :description
      t.string :category
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0
      t.integer :reorder_threshold, default: 0

      t.timestamps
    end
    add_index :products, [:company_id, :sku], unique: true
  end
end
