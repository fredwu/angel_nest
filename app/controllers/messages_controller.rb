class MessagesController < ApplicationController
  inherit_resources
  defaults :collection_name => 'comments'
  belongs_to :startup

  def create
    resource = parent.add_comment(current_user, params[:message][:content])

    respond_to do |format|
      format.json { render :json => resource }
      format.html { redirect_to :back }
    end
  end
end
