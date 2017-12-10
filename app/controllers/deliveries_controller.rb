class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy, :positions, :delivery, :activate, :recommended_path]
  respond_to :json, only: [ :positions, :recommended_path ]

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
    @business_position = { title: @business.address, position: { lat: @business.position.latitude, lng: @business.position.longitude } }.to_json
    respond_to do |format|
      format.html
      format.json { render json: { markers: @markers, business_position: @business_position } }
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

  def recommended_path
    gmaps = GoogleMapsService::Client.new
    @routes = gmaps.directions(
      "#{@business.address}",
      "#{@business.address}",
      waypoints: orders_as_path(@delivery),
      mode: 'driving',
      alternatives: false
    )
    respond_with @routes, location: [@business, :delivery]
  end

  private

  def orders_as_path(delivery)
    delivery_orders = delivery.sended_orders
    strategy = delivery.path_strategy
    orders = strategy.constantize.new(@business, delivery_orders.to_a).build_path.path
    orders.pop
    orders.shift
    waypoints = []
    orders.each do |order|
      waypoints << order.address
    end
    waypoints
  end

  def set_delivery
    @delivery = Delivery.find(params[:id])
  end

  def delivery_params
    params.require(:delivery).permit(:start_date, :end_date, :delivery_man_id, :path_strategy, :business_id, order_ids: [])
  end
end
