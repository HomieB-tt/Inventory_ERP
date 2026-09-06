class StockMovementsController < ApplicationController
  before_action -> { require_role!(:staff) }, only: [:new, :create]

  def index
    @stock_movements = Current.company.stock_movements
                               .includes(:product, :warehouse, :user)
                               .order(created_at: :desc)
    @stock_movements = @stock_movements.where(product_id: params[:product_id]) if params[:product_id].present?
    @stock_movements = @stock_movements.where(warehouse_id: params[:warehouse_id]) if params[:warehouse_id].present?

    @products = Current.company.products.order(:name)
    @warehouses = Current.company.warehouses.order(:name)
  end

  def new
    @stock_movement = Current.company.stock_movements.new
  end

  def create
    @stock_movement = Current.company.stock_movements.new(movement_params)
    # Hardcoded, not user-supplied: this form only ever creates manual
    # adjustments. Every other movement type is created by its own
    # business process (receiving, fulfilling, transferring), never by
    # directly permitting movement_type from a form.
    @stock_movement.movement_type = :manual_adjustment
    @stock_movement.user = Current.user

    if @stock_movement.save
      redirect_to stock_movements_path, notice: "Stock adjusted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def movement_params
    params.require(:stock_movement).permit(:product_id, :warehouse_id, :quantity, :notes)
  end
end
