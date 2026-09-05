class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :warehouses, dependent: :destroy
  has_many :suppliers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :stock_movements, dependent: :destroy
  has_many :purchase_orders, dependent: :destroy
  has_many :sales_orders, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end
end
