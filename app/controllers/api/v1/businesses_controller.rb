module  Api
  module V1
    class BusinessesController < Api::ApplicationController

      def index
        @businesses = Business.all
        render json: @businesses, each_serializer: BusinessSerializer
      end

    end
  end
end

