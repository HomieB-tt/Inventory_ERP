class CreatePurchaseOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :purchase_orders do |t|
      t.references :company, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.date :order_date, null: false
      t.date :expected_date

      t.timestamps
    end
  end
end
