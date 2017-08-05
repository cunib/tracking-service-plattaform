class PurchasesController < ApplicationController
  respond_to :html

  layout "frontend"

  def index
    @businesses = Business.all
  end

  def new_purchase
    @order = Order.new
    respond_with(@order)
  end

end
