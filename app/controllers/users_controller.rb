class UsersController < ApplicationController
  inherit_resources

  has_scope :page, :default => 1

  before_filter :hide_sidebar, :only => [:show, :message_inboxes]

  def index
    respond_to do |format|
      format.json { render :json => collection.for_auto_suggest }
      format.html { render 'users/_index', :locals => { :meta => {} } }
    end
  end

  def home
    @micro_posts = resource.followed_micro_posts.page(params[:p])
  end

  def show
    @micro_posts = resource.micro_posts.page(params[:p])
  end

  def message_inboxes
    @messages = case params[:type].try(:to_sym)
      when :inbox_messages     then current_user.inbox_messages
      when :sent_messages      then current_user.sent_messages
      when :archived_messages  then current_user.archived_messages
      when :inbox_proposals    then current_user.inbox_proposals
      when :sent_proposals     then current_user.sent_proposals
      when :archived_proposals then current_user.archived_proposals
      else redirect_to my_message_inbox_path(:inbox_messages)
    end
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

  def collection
    User.page(params[:page])
  end

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
