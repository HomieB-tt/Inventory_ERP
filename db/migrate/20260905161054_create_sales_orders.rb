class CreateSalesOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :sales_orders do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.string :customer_name
      t.date :order_date

      t.timestamps
    end
  end
end
