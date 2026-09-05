class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy, :receive]

  def index
    @purchase_orders = Current.company.purchase_orders.includes(:supplier).order(order_date: :desc)
  end

  def show
    @warehouses = Current.company.warehouses.order(:name)
  end

  def new
    @purchase_order = Current.company.purchase_orders.new(order_date: Date.current)
    3.times { @purchase_order.purchase_order_lines.build }
  end

  def create
    @purchase_order = Current.company.purchase_orders.new(purchase_order_params)
    @purchase_order.user = Current.user
    if @purchase_order.save
      redirect_to @purchase_order, notice: "Purchase order created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @purchase_order.purchase_order_lines.build if @purchase_order.purchase_order_lines.empty?
  end

  def update
    if @purchase_order.update(purchase_order_params)
      redirect_to @purchase_order, notice: "Purchase order updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @purchase_order.destroy
    redirect_to purchase_orders_path, notice: "Purchase order deleted."
  end

  def receive
    warehouse = Current.company.warehouses.find(params[:warehouse_id])
    @purchase_order.receive!(warehouse: warehouse, received_by: Current.user)
    redirect_to @purchase_order, notice: "Stock received into #{warehouse.name}."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @purchase_order, alert: "Could not receive stock: #{e.message}"
  end

  private

  def set_purchase_order
    @purchase_order = Current.company.purchase_orders.find(params[:id])
  end

  def purchase_order_params
    params.require(:purchase_order).permit(
      :supplier_id, :order_date, :expected_date, :status,
      purchase_order_lines_attributes: [:id, :product_id, :quantity_ordered, :unit_cost, :_destroy]
    )
  end
end
