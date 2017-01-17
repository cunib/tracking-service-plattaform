require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  protect_from_forgery

  responders :flash, :collection
  respond_to :html

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionView::Template::Error,  with: :render_server_error
  #rescue_from CanCan::AccessDenied,         with: :render_forbidden

  def render_not_found(exception = nil)
    log_error(exception, 'NotFound') if exception
    render template: 'application/not_found', status: 404
  end

  def render_server_error(exception = nil)
    log_error(exception, 'ServerError') if exception
    render template: 'application/server_error', status: 500
  end

# def render_forbidden(exception = nil)
#   log_error(exception, 'Forbidden') if exception
#   render template: 'application/forbidden', status: 403
# end

  def session_params
    session_name = params[:controller]
    if params.has_key?(:_reset)
      session.delete("#{session_name}_search".to_sym)
      return nil
    end
    session["#{session_name}_search".to_sym] = params[:q] if params[:q].present?
    session["#{session_name}_search".to_sym]
  end

  private

  def log_error(exception, section = nil)
    if Rails.env.production?
      Rails.logger.error(section) { "exception=#{exception.class} message=#{exception.message} trace=#{exception.backtrace.join(';')}" }
    else
      raise exception
    end
  end

  def page_param
    params[:page] || 1
  end
end
