class CreateWarehouses < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouses do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :location

      t.timestamps
    end
    add_index :warehouses, [:company_id, :name], unique: true
  end
end
