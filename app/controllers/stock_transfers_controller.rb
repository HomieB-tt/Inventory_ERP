class StockTransfersController < ApplicationController
  before_action -> { require_role!(:staff) }, only: [:new, :create]

  def index
    @transfers = Current.company.stock_transfers
                         .includes(:product, :from_warehouse, :to_warehouse, :user)
                         .order(created_at: :desc)
  end

  def new
    @transfer = Current.company.stock_transfers.new
  end

  def create
    @transfer = Current.company.stock_transfers.new(transfer_params)
    @transfer.user = Current.user
    ActiveRecord::Base.transaction do
      @transfer.save!
      @transfer.execute!
    end
    redirect_to stock_transfers_path, notice: "Transferred #{@transfer.quantity} units."
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def transfer_params
    params.require(:stock_transfer).permit(:product_id, :from_warehouse_id, :to_warehouse_id, :quantity)
  end
end
