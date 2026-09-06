class SalesOrdersController < ApplicationController
  before_action -> { require_role!(:staff) }, only: [:new, :create, :edit, :update, :fulfill]
  before_action -> { require_role!(:admin) }, only: [:destroy]
  before_action :set_sales_order, only: [:show, :edit, :update, :destroy, :fulfill]

  def index
    @sales_orders = Current.company.sales_orders.order(order_date: :desc)
  end

  def show
    @warehouses = Current.company.warehouses.order(:name)
  end

  def new
    @sales_order = Current.company.sales_orders.new(order_date: Date.current)
    @sales_order.sales_order_lines.build
  end

  def create
    @sales_order = Current.company.sales_orders.new(sales_order_params)
    @sales_order.user = Current.user
    if @sales_order.save
      redirect_to @sales_order, notice: "Sales order created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @sales_order.sales_order_lines.build if @sales_order.sales_order_lines.empty?
  end

  def update
    if @sales_order.update(sales_order_params)
      redirect_to @sales_order, notice: "Sales order updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sales_order.destroy
    redirect_to sales_orders_path, notice: "Sales order deleted."
  end

  def fulfill
    warehouse = Current.company.warehouses.find(params[:warehouse_id])
    @sales_order.fulfill!(warehouse: warehouse, fulfilled_by: Current.user)
    redirect_to @sales_order, notice: "Order fulfilled from #{warehouse.name}."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @sales_order, alert: "Could not fulfill order: #{e.message}"
  end

  private

  def set_sales_order
    @sales_order = Current.company.sales_orders.find(params[:id])
  end

  def sales_order_params
    params.require(:sales_order).permit(
      :customer_name, :order_date, :status,
      sales_order_lines_attributes: [:id, :product_id, :quantity, :unit_price, :_destroy]
    )
  end
end
