module  Api
  class ApplicationController < ActionController::API
    include ActionController::Caching

    rescue_from Exception,                           with: :render_server_error
    rescue_from ActionController::UnknownController, with: :render_not_found
    rescue_from ActionController::RoutingError,      with: :render_not_found
    rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found

    def render_not_found(exception = nil)
      log_error(exception, 'NotFound') if exception
      render json: ErrorResource.new(exception), status: :not_found
    end

    def render_server_error(exception = nil)
      log_error(exception, 'ServerError') if exception
      render json: ErrorResource.new(exception), status: :internal_server_error
    end

    private

    def log_error(exception, section = nil)
      if Rails.env.production?
        Rails.logger.error(section) { "exception=#{exception.class} message=#{exception.message} trace=#{exception.backtrace.join(';')}" }
      else
        raise exception
      end
    end

  end
end
