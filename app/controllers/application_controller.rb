require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  check_authorization unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: {}, status: :forbidden }
      format.js   { render :file => "#{Rails.root}/public/403.js", status: :forbidden }
    end
  end
end
