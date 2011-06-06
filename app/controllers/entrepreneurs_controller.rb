class EntrepreneursController < ApplicationController
  inherit_resources

  def index
    render 'users/index'
  end

  def collection
    User.entrepreneurs
  end
end
