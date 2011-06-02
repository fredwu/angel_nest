class UsersController < ApplicationController
  inherit_resources
  include AngelNest::AutoUserScoping

  def home
    @micro_posts = resource.followed_micro_posts
  end

  def show
    @micro_posts = resource.micro_posts
  end

  def add_micro_post
    result = current_user.add_micro_post(params[:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end
end
