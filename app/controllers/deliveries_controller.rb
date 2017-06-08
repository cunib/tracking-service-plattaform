class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @deliveries = Delivery.all
    @q = @deliveries.search(session_params)
    @q.sorts = ["created_at desc"]
    @deliveries = @q.result.page(page_param)
    respond_with(@deliveries)
  end

  def show
    respond_with(@delivery)
  end

  def new
    @delivery = Delivery.new
    respond_with(@delivery)
  end

  def edit
  end

  def create
    @delivery = Delivery.new(delivery_params)
    @delivery.save
    respond_with(@delivery)
  end

  def update
    @delivery.update(delivery_params)
    respond_with(@delivery)
  end

  def destroy
    @delivery.destroy
    respond_with(@delivery)
  end

  private
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    def delivery_params
      params.require(:delivery).permit(:start_date, :end_date, :delivery_man_id)
    end
end