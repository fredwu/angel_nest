class InvestorsController < ApplicationController
  inherit_resources

  def index
    render 'users/index'
  end

  def collection
    User.investors
  end
end
