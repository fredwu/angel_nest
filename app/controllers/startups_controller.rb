class StartupsController < ApplicationController
  inherit_resources
  belongs_to :user, :optional => true

  include AutoUserScoping

  before_filter :hide_sidebar, :only => [:show, :edit]
  after_filter  :attach_user_to_startup, :only => :create

  private

  def attach_user_to_startup
    resource.attach_user(parent) if resource.persisted?
  end
end
