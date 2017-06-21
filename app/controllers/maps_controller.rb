class MapsController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :cancel, :suspend]


  def index
    @markers = []
    respond_to do |format|
      format.html
      format.json { render json: { projects: {}, markers: @markers, 
                                   community_center_markers: [] } }
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

end
