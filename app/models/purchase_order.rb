class PurchaseOrder < ApplicationRecord
  belongs_to :company
  belongs_to :supplier
  belongs_to :user
  has_many :purchase_order_lines, dependent: :destroy
  accepts_nested_attributes_for :purchase_order_lines, reject_if: :all_blank, allow_destroy: true

  enum :status, { draft: 0, ordered: 1, received: 2, cancelled: 3 }

  validates :order_date, presence: true

  def total_cost
    purchase_order_lines.sum { |line| line.quantity_ordered * line.unit_cost }
  end

  # Receiving stock: creates a StockMovement per line and marks lines received
  def receive!(warehouse:, received_by:)
    transaction do
      purchase_order_lines.each do |line|
        remaining = line.quantity_ordered - line.quantity_received
        next if remaining <= 0

        StockMovement.create!(
          company: company, product: line.product, warehouse: warehouse,
          user: received_by, quantity: remaining,
          movement_type: :purchase_receipt,
          reference_type: "PurchaseOrder", reference_id: id
        )
        line.update!(quantity_received: line.quantity_ordered)
      end
      update!(status: :received)
    end
  end
end
