class UsersController < ApplicationController
  inherit_resources

  has_scope :page, :default => 1

  def home
    @micro_posts = resource.followed_micro_posts.page(params[:p])
  end

  def show
    hide_sidebar
    @micro_posts = resource.micro_posts.page(params[:p])
  end

  def add_micro_post
    result = current_user.add_micro_post(params[:message][:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  def follow_target
    result = current_user.follow(target)

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  def unfollow_target
    result = current_user.unfollow(target)

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  private

  def resource
    if params.key?(:username)
      User.find_by_username(params[:username])
    elsif params.key?(:id)
      super
    else
      current_user
    end
  end

  def target
    params[:target_type].constantize.find(params[:target_id])
  end
end
