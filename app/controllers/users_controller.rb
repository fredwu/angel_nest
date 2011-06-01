class UsersController < ApplicationController
  inherit_resources

  def show
    @micro_posts = resource.micro_posts
  end

  def followed_micro_posts
    @micro_posts = resource.followed_micro_posts
  end

  def add_micro_post
    result = current_user.add_micro_post(params[:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  private

  def resource
    super
  rescue ActiveRecord::RecordNotFound
    current_user
  end
end
