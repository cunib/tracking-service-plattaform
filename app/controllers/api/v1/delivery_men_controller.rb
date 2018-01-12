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
        @path_orders = path_information.try(:path) || []
        not_sended_orders = delivery.try(:not_sended_orders) || []
        @orders = @path_orders + not_sended_orders
        render json: @orders, include: [:position, :delivery, :business, :products, :ordered_products], key_transform: :underscore
      end

      private

      def orders_as_path(delivery)
        delivery_orders = delivery.sended_and_finalized_orders
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

