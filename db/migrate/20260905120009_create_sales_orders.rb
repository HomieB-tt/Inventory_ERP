class CreateSalesOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :sales_orders do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :customer_name, null: false
      t.date :order_date, null: false

      t.timestamps
    end
  end
end
