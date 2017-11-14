class DeliveryMenController < ApplicationController
  before_action :set_delivery_man, only: [:show, :edit, :update, :destroy, :deliveries]

  respond_to :html

  def index
    @delivery_men = @business.delivery_men
    @q = @delivery_men.search(session_params)
    @q.sorts = ["created_at desc"]
    @delivery_men = @q.result.page(page_param)
    respond_with(@delivery_men, locales: [@business, :delivery_men])
  end

  def show
  end

  def new
    @delivery_man = DeliveryMan.new
  end

  def edit
  end

  def create
    @delivery_man = DeliveryMan.new(delivery_man_params)
    @delivery_man.trace = Trace.create
    @delivery_man.save
    respond_with(@delivery_man, location: [@business, :delivery_men])
  end

  def update
    @delivery_man.update(delivery_man_params)
    respond_with(@delivery_man, location: [@business, :delivery_man])
  end

  def destroy
    @delivery_man.destroy
    respond_with(@delivery_man, location: [@business, :delivery_men])
  end
  
  def deliveries
    @delivery_man.deliveries
  end

  private

  def set_delivery_man
    @delivery_man = DeliveryMan.find(params[:id])
  end

  def delivery_man_params
    params.require(:delivery_man).permit(:nickname, :business_id)
  end
end
