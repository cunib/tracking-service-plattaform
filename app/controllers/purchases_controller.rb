class PurchasesController < ApplicationController
  respond_to :html

  layout "frontend"

  def make_purchase
    @order = Order.new
    respond_with(@order)
  end

end
