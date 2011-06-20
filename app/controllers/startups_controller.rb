class StartupsController < ApplicationController
  inherit_resources

  include AutoUserScoping

  before_filter :hide_sidebar, :only => [:show, :edit]
  after_filter  :attach_user_to_startup, :only => :create

  def attach_user

  end

  def update_user
    if request.post?
      resource.update_user(User.find(params[:uid]), params[:attributes])
    end
  end

  def detach_user
    if request.post?
      user = User.find(params[:uid])
      resource.detach_user(user)
    end
  end

  private

  def attach_user_to_startup
    resource.attach_user(parent) if resource.persisted?
  end
end
