class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :company, null: false, foreign_key: true
      t.string :sku
      t.string :name
      t.text :description
      t.string :category
      t.decimal :unit_price
      t.integer :reorder_threshold

      t.timestamps
    end
  end
end
