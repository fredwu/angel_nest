class ApplicationController < ActionController::Base
  protect_from_forgery

  layout proc { |controller| controller.request.xhr? ? nil : 'application' }

  before_filter :require_login, :unless => :devise_controller?

  private

  def require_login
    redirect_to new_user_session_url unless current_user
  end
end
