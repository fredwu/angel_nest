class MessagesController < ApplicationController
  inherit_resources

  defaults :collection_name => 'comments'

  belongs_to :startup

  has_scope :p, :default => 1

  before_filter :hide_sidebar, :only => [:show_private_message]
  before_filter :ensure_ownership, :only => [:show_private_message, :reply_private_message]

  def create
    resource = parent.add_comment(current_user, params[:message][:content])

    respond_to do |format|
      format.json { render :json => resource }
      format.html { redirect_to :back }
    end
  end

  def send_private_message
    result = current_user.send_private_message(User.find(params[:message][:users] || params[:users]), params[:message][:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  def show_private_message
    @topic = Message.topics.find(params[:id])
  end

  def reply_private_message
    @topic = Message.topics.find(params[:id])
    result = current_user.reply_private_message(@topic, params[:message][:content])

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :back }
    end
  end

  def archive_private_message
    Message.topics.find(params[:id]).mark_as_archived!

    respond_to do |format|
      format.json { render :json => result }
      format.html do
        flash[:success] = t('text.message_is_archived')
        redirect_to :back
      end
    end
  end
end
