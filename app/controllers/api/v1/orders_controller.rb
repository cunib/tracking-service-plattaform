module  Api
  module V1
    class OrdersController < Api::ApplicationController

      def index
        @orders = Order.all
        render json: @orders, each_serializer: OrderSerializer
      end

      private

      def order_params
        permit_params(:start_date, :end_date, :business_id, :address,
                      :status)
      end

    end
  end
end

