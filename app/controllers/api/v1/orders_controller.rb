module  Api
  module V1
    class OrdersController < Api::ApplicationController
      before_action :set_order, only: [:mark_as_finalized, :mark_as_suspended, :mark_as_canceled]

      def index
        @orders = Order.all
        render json: @orders
      end

      def mark_as_finalized
        if @order.finalize
          @order.update end_date: DateTime.now
          render nothing: true, status: :ok
        else
          render nothing: true, status: :method_not_allowed
        end
      end

      def mark_as_suspended
        if @order.suspend
          render nothing: true, status: :ok
        else
          render nothing: true, status: :method_not_allowed
        end
      end

      def mark_as_canceled
        if @order.cancel
          render nothing: true, status: :ok
        else
          render nothing: true, status: :method_not_allowed
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        permit_params(:start_date, :end_date, :business_id, :address,
                      :status)
      end

    end
  end
end

