class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy, :make_order]

  respond_to :html

  def index
    @businesses = Business.all
    @q = @businesses.search(session_params)
    @q.sorts = ["created_at desc"]
    @businesses = @q.result.page(page_param)
    respond_with(@businesses)
  end

  def show
    respond_with(@business)
  end

  def new
    @business = Business.new
    respond_with(@business)
  end

  def edit
  end

  def create
    @business = Business.new(business_params)
    @business.save
    respond_with(@business)
  end

  def update
    @business.update(business_params)
    respond_with(@business)
  end

  def destroy
    @business.destroy
    respond_with(@business)
  end

  def business_sellection

  end

  private

  def set_business
    business_param = params[:id] || params[:business_id]
    @business = Business.find(business_param)
  end

  def business_params
    params.require(:business).permit(:name, :address)
  end
end
