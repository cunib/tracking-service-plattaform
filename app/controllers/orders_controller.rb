class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel, 
                                   :suspend, :process_order, :dispatch_order, :positions,
                                  :mark_as_sended_order]

  respond_to :html
  respond_to :json, only: :positions
  layout 'frontend', only: [:new_order, :create_order, :track_order, :positions]

  def index
    @orders = @business.orders
    @q = @orders.search(session_params)
    @q.sorts = ["start_date desc"]
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
    @order.business = @business
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

  def mark_as_sended_order
    @order.mark_as_sended
    respond_with(@order, location: [@business, :orders])
  end


  def process_order
    @order.process
    respond_with(@order, location: [@business, :orders])
  end

  def dispatch_order
    @order.dispatch
    respond_with(@order, location: [@business, :orders])
  end

  def suspend
    @order.suspend
    respond_with(@order, location: [@business, :orders])
  end

  def cancel
    @order.cancel
    @order.update end_date: DateTime.now if @order.errors.empty?
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
    @order = Order.new(order_params)
    @order.position = Position.create
    @order.business = @business
    @order.save
    if @order.errors.any?
      flash[:alert] = I18n.t 'flash.orders.create_order.alert'
      render :new_order
    else
      @show_trackit_link = true
      flash.now[notice] = I18n.t('flash.orders.create_order.notice', hash_code: @order.hash_code).html_safe
      render :track_order
    end
  end

  def track_order
    @order = Order.find_by(hash_code: order_params[:hash_code]) unless params[:_reset].present? || params[:order].blank?
    respond_with @order, location: [@business, :track_order], action: :track_order
  end

  def positions
    if @order.sended?
      @positions = @order.serialized_positions
      respond_with @positions, location: [@business, :track_order]
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:start_date, :end_date, :address, :business_id, 
                                  :delivery_id, :hash_code, :customer_full_name,
                                  :customer_email, product_ids: [])
  end
end
