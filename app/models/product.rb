class Product < ApplicationRecord
  belongs_to :company
  has_many :stock_movements, dependent: :restrict_with_error
  has_many :purchase_order_lines, dependent: :restrict_with_error
  has_many :sales_order_lines, dependent: :restrict_with_error

  validates :sku, presence: true, uniqueness: { scope: :company_id }
  validates :name, presence: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  def stock_on_hand(warehouse: nil)
    scope = stock_movements
    scope = scope.where(warehouse: warehouse) if warehouse
    scope.sum(:quantity)
  end

  def low_stock?
    stock_on_hand <= reorder_threshold
  end
end
