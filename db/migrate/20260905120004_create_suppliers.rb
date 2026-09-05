class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :contact_email
      t.string :phone
      t.text :address

      t.timestamps
    end
  end
end
