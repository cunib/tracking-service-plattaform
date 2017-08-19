class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel, :suspend]

  respond_to :html
  layout 'frontend', only: :new_order

  def index
    @orders = @business.orders
    @q = @orders.search(session_params)
    @q.sorts = ["created_at desc"]
    @orders = @q.result.page(page_param)
    respond_with(@orders, location: [@business, :orders])
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
    @order.position = Position.create
    @order.save
    respond_with(@order, location: [@business, :orders])
  end

  def update
    @order.update(order_params)
    respond_with(@order, location: [@business, :order])
  end

  def destroy
    @order.destroy
    respond_with(@order, location: [@business, :orders])
  end

  def cancel
    @order.cancel
    respond_with(@order, location: [@business, :orders])
  end

  def suspend
    @order.suspend
    respond_with(@order, location: [@business, :orders])
  end

  def new_order
    @products = @business.products
    @order = Order.new
    @q = @products.search(session_params)
    @q.sorts = ["created_at desc"]
    @products = @q.result.page(page_param)
  end

  def create_order
    #Aca se debería devolver un hash para el seguimiento de la orden
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:start_date, :end_date, :address, :business_id, :delivery_id)
  end
end
