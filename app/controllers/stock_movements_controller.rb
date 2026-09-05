class StockMovementsController < ApplicationController
  def index
    @stock_movements = Current.company.stock_movements
                               .includes(:product, :warehouse, :user)
                               .order(created_at: :desc)
    @stock_movements = @stock_movements.where(product_id: params[:product_id]) if params[:product_id].present?
    @stock_movements = @stock_movements.where(warehouse_id: params[:warehouse_id]) if params[:warehouse_id].present?

    @products = Current.company.products.order(:name)
    @warehouses = Current.company.warehouses.order(:name)
  end
end
