class WarehousesController < ApplicationController
  before_action -> { require_role!(:staff) }, only: [:new, :create, :edit, :update]
  before_action -> { require_role!(:admin) }, only: [:destroy]
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  def index
    @warehouses = Current.company.warehouses.order(:name)
  end

  def show
  end

  def new
    @warehouse = Current.company.warehouses.new
  end

  def create
    @warehouse = Current.company.warehouses.new(warehouse_params)
    if @warehouse.save
      redirect_to @warehouse, notice: "Warehouse created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @warehouse.update(warehouse_params)
      redirect_to @warehouse, notice: "Warehouse updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @warehouse.destroy
    redirect_to warehouses_path, notice: "Warehouse deleted."
  end

  private

  def set_warehouse
    @warehouse = Current.company.warehouses.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :location)
  end
end
