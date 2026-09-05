class StockMovement < ApplicationRecord
  belongs_to :company
  belongs_to :product
  belongs_to :warehouse
  belongs_to :user

  enum :movement_type, {
    purchase_receipt: 0,
    sale: 1,
    manual_adjustment: 2,
    transfer_in: 3,
    transfer_out: 4
  }

  validates :quantity, numericality: { other_than: 0 }
  validate :quantity_sign_matches_movement_type

  private

  def quantity_sign_matches_movement_type
    outgoing = %w[sale transfer_out].include?(movement_type)
    if outgoing && quantity.positive?
      errors.add(:quantity, "must be negative for #{movement_type}")
    elsif !outgoing && movement_type != "manual_adjustment" && quantity.negative?
      errors.add(:quantity, "must be positive for #{movement_type}")
    end
  end
end
