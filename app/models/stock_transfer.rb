class StockTransfer < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :from_warehouse, class_name: "Warehouse"
  belongs_to :to_warehouse, class_name: "Warehouse"
  belongs_to :user

  validates :quantity, numericality: { greater_than: 0 }
  validate :warehouses_differ
  validate :sufficient_stock

  # Creates the paired transfer_out/transfer_in StockMovement rows. Call
  # this only after the transfer itself has been saved (it needs an id
  # to reference). The controller wraps save! + execute! in one
  # transaction so a failure here rolls back the transfer record too.
  def execute!
    StockMovement.create!(
      company: company, product: product, warehouse: from_warehouse,
      user: user, quantity: -quantity, movement_type: :transfer_out,
      reference_type: "StockTransfer", reference_id: id
    )
    StockMovement.create!(
      company: company, product: product, warehouse: to_warehouse,
      user: user, quantity: quantity, movement_type: :transfer_in,
      reference_type: "StockTransfer", reference_id: id
    )
  end

  private

  def warehouses_differ
    return if from_warehouse_id.blank? || to_warehouse_id.blank?
    if from_warehouse_id == to_warehouse_id
      errors.add(:to_warehouse_id, "must be different from the source warehouse")
    end
  end

  def sufficient_stock
    return if product.nil? || from_warehouse.nil? || quantity.nil?
    if product.stock_on_hand(warehouse: from_warehouse) < quantity
      errors.add(:quantity, "exceeds available stock at the source warehouse")
    end
  end
end
