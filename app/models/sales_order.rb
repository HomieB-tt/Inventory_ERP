class SalesOrder < ApplicationRecord
  belongs_to :company
  belongs_to :user
  has_many :sales_order_lines, dependent: :destroy

  enum :status, { draft: 0, confirmed: 1, fulfilled: 2, cancelled: 3 }

  validates :customer_name, presence: true
  validates :order_date, presence: true

  def total_price
    sales_order_lines.sum { |line| line.quantity * line.unit_price }
  end

  def fulfill!(warehouse:, fulfilled_by:)
    transaction do
      sales_order_lines.each do |line|
        StockMovement.create!(
          company: company, product: line.product, warehouse: warehouse,
          user: fulfilled_by, quantity: -line.quantity,
          movement_type: :sale,
          reference_type: "SalesOrder", reference_id: id
        )
      end
      update!(status: :fulfilled)
    end
  end
end
