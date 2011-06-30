class InvestorsController < ApplicationController
  inherit_resources

  belongs_to :user, :optional => true

  def index
    respond_to do |format|
      format.json { render :json => collection.for_auto_suggest }
      format.html { render 'users/_index', :locals => { :meta => {} } }
    end
  end

  private

  def collection
    User.investors.page(params[:page])
  end
end
