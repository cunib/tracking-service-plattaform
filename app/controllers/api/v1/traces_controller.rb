module  Api
  module V1
    class TracesController < Api::ApplicationController

      def create
        trace_create_params.delete :serial_version_uid
        delivery_man = DeliveryMan.find(trace_create_params.delete :delivery_man_id)
        # Desharcodear delivery!!!!!!!!!!!!!!!!!!!!!!!!111
        trace = Trace.build_trace(trace_create_params)
        if delivery_man.update_trace trace
          render nothing: true, status: :ok
        else
          p "ERRORES #{@trace.errors}"
          render nothing: true, status: :service_unavailable
        end
      end

      private

      def trace_create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse!(params)
      end
    end
  end
end

