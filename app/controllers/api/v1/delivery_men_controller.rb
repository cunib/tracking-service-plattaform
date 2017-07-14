module  Api
  module V1
    class DeliveryMenController < Api::ApplicationController
      before_action :set_delivery_man, only: [:show, :active_delivery_orders, :new_positions]

      def show
        render json: @delivery_man
      end

      def active_delivery_orders
        @delivery_orders = @delivery_man.deliveries.last.orders
        render json: @delivery_orders, each_serializer: OrdersSerializer
      end

      def new_positions
        if @delivery_man.update_trace delivery_man_params.to_h[:positions]
          render nothing: true, status: :ok
        else
          render nothing: true, status: :service_unavailable
        end
      end

      private

      def set_delivery_man
        @delivery_man = DeliveryMan.find(params[:id])
      end

      def delivery_man_params
        params.require(:delivery_man).permit(positions: [:latitude, :longitude])
      end
    end
  end
end

