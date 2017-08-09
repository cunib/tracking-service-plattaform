class PurchasesController < ApplicationController
  respond_to :html
  skip_before_filter :set_business

  layout "frontend"

  def index
    @businesses = Business.all
  end

  def new_purchase
    @order = Order.new
    respond_with(@order)
  end

end
