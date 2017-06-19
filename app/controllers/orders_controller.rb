class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel, :suspend]

  respond_to :html

  def index
    @orders = Order.all
    @q = @orders.search(session_params)
    @q.sorts = ["created_at desc"]
    @orders = @q.result.page(page_param)
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @order.save
    respond_with(@order)
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  def cancel
    @order.cancel
    respond_with(@order)
  end

  def suspend
    @order.suspend
    respond_with(@order)
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:start_date, :end_date, :address, :business_id)
    end
end
