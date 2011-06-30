class EntrepreneursController < ApplicationController
  inherit_resources

  def index
    render 'users/_index', :locals => { :meta => {} }
  end

  def collection
    User.entrepreneurs.page(params[:page])
  end
end
