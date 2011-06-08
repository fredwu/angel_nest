class InvestorsController < ApplicationController
  inherit_resources
  belongs_to :user, :optional => true

  def index
    render 'users/index'
  end

  def collection
    User.investors
  end
end
