class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy, :positions, :delivery, :activate]
  respond_to :json, only: :positions

  respond_to :html

  def index
    @deliveries = @business.deliveries
    @q = @deliveries.search(session_params)
    @q.sorts = ["created_at asc"]
    @deliveries = @q.result.page(page_param)
    respond_with(@deliveries, locales: [@business, :deliveries])
  end

  def show
    @markers = @delivery.serialized_orders
    respond_to do |format|
      format.html
      format.json { render json: { markers: @markers } }
    end
  end

  def new
    @delivery = Delivery.new
  end

  def edit
  end

  def create
    @delivery = Delivery.create delivery_params
      .merge(path_strategy: @business.path_strategy, business: @business)
    respond_with(@delivery, location: [@business, :deliveries])
  end

  def update
    @delivery.update(delivery_params)
    respond_with(@delivery, location: [@business, :delivery])
  end

  def destroy
    @delivery.destroy
    respond_with(@delivery, location: [@business, :deliveries])
  end

  def positions
    @positions = @delivery.serialized_positions
    respond_with @positions, location: [@business, :delivery]
  end

  def activate
    @delivery.activate
    respond_with(@delivery, location: [@business, :deliveries])
  end

  private

  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  def delivery_params
    params.require(:delivery).permit(:start_date, :end_date, :delivery_man_id, :path_strategy, :business_id, order_ids: [])
  end
end
