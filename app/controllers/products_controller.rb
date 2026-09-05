class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Current.company.products.order(:name)
  end

  def show
    @stock_by_warehouse = Current.company.warehouses.map do |w|
      [w, @product.stock_on_hand(warehouse: w)]
    end
  end

  def new
    @product = Current.company.products.new
  end

  def create
    @product = Current.company.products.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted."
  end

  private

  def set_product
    @product = Current.company.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :category, :unit_price, :reorder_threshold)
  end
end
