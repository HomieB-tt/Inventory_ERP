class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = Current.company.suppliers.order(:name)
  end

  def show
  end

  def new
    @supplier = Current.company.suppliers.new
  end

  def create
    @supplier = Current.company.suppliers.new(supplier_params)
    if @supplier.save
      redirect_to @supplier, notice: "Supplier created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: "Supplier updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @supplier.destroy
    redirect_to suppliers_path, notice: "Supplier deleted."
  end

  private

  def set_supplier
    @supplier = Current.company.suppliers.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :contact_email, :phone, :address)
  end
end
