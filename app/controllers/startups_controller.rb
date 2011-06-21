class StartupsController < ApplicationController
  inherit_resources

  include AutoUserScoping

  before_filter :hide_sidebar, :only => [:show, :edit]
  after_filter  :attach_founder_to_startup, :only => :create

  def attach_user
    if request.post?
      result = resource.invite_or_attach_user(params[:role_identifier], params[:attributes])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    end
  end

  def update_user
    if request.post?
      result = resource.update_user(User.find(params[:uid]), params[:role_identifier], params[:attributes])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    end
  end

  def detach_user
    if request.post?
      user   = User.find(params[:uid])
      result = resource.detach_user(user, params[:role_identifier])

      respond_to do |format|
        format.json { render :json => result }
        format.html { redirect_to resource_path(resource) }
      end
    end
  end

  private

  def attach_founder_to_startup
    if resource.persisted?
      resource.attach_user(parent, :member, t('label.founder'))
      resource.confirm_user(parent)
    end
  end
end
