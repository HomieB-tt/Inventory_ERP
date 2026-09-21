require "csv"

class ProductsController < ApplicationController
  before_action -> { require_role!(:staff) }, only: [:new, :create, :edit, :update, :new_import, :import]
  before_action -> { require_role!(:admin) }, only: [:destroy]
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

  # Read-only, so available to any signed-in role, same as index/show.
  def export
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["sku", "name", "description", "category", "unit_price", "reorder_threshold", "total_stock_on_hand"]
      Current.company.products.order(:name).each do |p|
        csv << [p.sku, p.name, p.description, p.category, p.unit_price, p.reorder_threshold, p.stock_on_hand]
      end
    end
    send_data csv_data, filename: "products-#{Date.current.iso8601}.csv", type: "text/csv"
  end

  def new_import
  end

  def import
    file = params[:file]
    if file.blank?
      redirect_to new_import_products_path, alert: "Please choose a CSV file to upload."
      return
    end

    results = { created: 0, updated: 0, errors: [] }

    CSV.parse(file.read, headers: true, header_converters: :downcase) do |row|
      sku = row["sku"]&.strip
      if sku.blank?
        results[:errors] << "Row skipped: missing SKU"
        next
      end

      product = Current.company.products.find_or_initialize_by(sku: sku)
      was_new_record = product.new_record?

      product.assign_attributes(
        name: row["name"],
        description: row["description"],
        category: row["category"],
        unit_price: row["unit_price"],
        # Blank would otherwise assign nil (the column allows null), and
        # Product#low_stock? does `stock_on_hand <= reorder_threshold`,
        # which raises on a nil comparison. Default to 0 instead.
        reorder_threshold: row["reorder_threshold"].presence || 0
      )

      if product.save
        was_new_record ? results[:created] += 1 : results[:updated] += 1
      else
        results[:errors] << "#{sku}: #{product.errors.full_messages.join(', ')}"
      end
    end

    if results[:errors].any?
      redirect_to products_path, alert: import_summary(results)
    else
      redirect_to products_path, notice: import_summary(results)
    end
  end

  private

  def import_summary(results)
    summary = "Import complete: #{results[:created]} created, #{results[:updated]} updated."
    if results[:errors].any?
      summary += " #{results[:errors].size} row(s) had errors: #{results[:errors].join('; ')}"
    end
    summary
  end

  def set_product
    @product = Current.company.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :category, :unit_price, :reorder_threshold)
  end
end
