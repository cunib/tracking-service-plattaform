module  Api
  module V1
    class TracesController < Api::ApplicationController

      def create
        if UpdateTrace.call(trace_create_params)
          render nothing: true, status: :ok
        else
          render nothing: true, status: :service_unavailable
        end
      end

      private

      def trace_create_params
        trace_params = ActiveModelSerializers::Deserialization.jsonapi_parse!(params)
        trace_params.delete :serial_version_uid
        trace_params
      end
    end
  end
end

