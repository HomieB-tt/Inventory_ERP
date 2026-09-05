class DashboardController < ApplicationController
  def index
    @low_stock_products = Current.company.products.select(&:low_stock?)
    @recent_movements = Current.company.stock_movements
                                .includes(:product, :warehouse, :user)
                                .order(created_at: :desc).limit(10)
    @counts = {
      products: Current.company.products.count,
      warehouses: Current.company.warehouses.count,
      suppliers: Current.company.suppliers.count,
      open_purchase_orders: Current.company.purchase_orders.where(status: [:draft, :ordered]).count,
      open_sales_orders: Current.company.sales_orders.where(status: [:draft, :confirmed]).count
    }
  end
end
