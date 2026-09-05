class Warehouse < ApplicationRecord
  belongs_to :company
  has_many :stock_movements, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :company_id }
end
