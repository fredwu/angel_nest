class UsersController < ApplicationController
  inherit_resources

  def followed_micro_posts
    @micro_posts = current_user.followed_micro_posts
  end

  def add_micro_post
    result = current_user.add_micro_post(params[:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end
end
