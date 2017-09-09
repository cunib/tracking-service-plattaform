module  Api
  module V1
    class DeliveryMenController < Api::ApplicationController
      before_action :set_delivery_man, only: [:show, :active_delivery_orders, :new_positions]

      def show
        render json: @delivery_man
      end

      def active_delivery_orders
        delivery = @delivery_man.active_delivery
        path_information = orders_as_path(delivery) if delivery.present?
        @orders = path_information.try(:path) || []
        render json: @orders, include: [:position, :delivery, :business], key_transform: :underscore
      end

      def new_positions
        if @delivery_man.update_trace delivery_man_params.to_h[:positions]
          render nothing: true, status: :ok
        else
          render nothing: true, status: :service_unavailable
        end
      end

      private

      def orders_as_path(delivery)
        delivery_orders = delivery.orders
        strategy = delivery.path_strategy
        strategy.constantize.new(@delivery_man.business, delivery_orders.to_a).build_path
      end

      def set_delivery_man
        @delivery_man = DeliveryMan.find(params[:id])
      end

      def delivery_man_params
        params.require(:delivery_man).permit(positions: [:latitude, :longitude])
      end
    end
  end
end

