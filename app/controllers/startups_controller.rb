class StartupsController < ApplicationController
  inherit_resources
  belongs_to :user, :optional => true
  include AngelNest::AutoUserScoping

  after_filter :attach_user_to_startup, :only => :create

  private

  def attach_user_to_startup
    resource.attach_user(parent) if resource.persisted?
  end
end
