class ApplicationController < ActionController::Base
  protect_from_forgery

  layout proc { |controller| controller.request.xhr? ? nil : 'application' }

  before_filter :require_login, :unless => :devise_controller?
  before_filter :ensure_ownership, :except => [:index, :show], :unless => :devise_controller?

  private

  def require_login
    redirect_to new_user_session_url unless current_user
  end

  def ensure_ownership
    if resource_class == User
      deny_access unless current_user == resource
    elsif parent_class == User
      deny_access unless current_user == parent
    elsif params.key?(:user_id)
      deny_access unless current_user == User.find(params[:user_id])
    end
  end

  def deny_access
    render :text => t('system.access_denied'), :status => 403
  end

  def hide_sidebar
    @hide_sidebar = true
  end
end
