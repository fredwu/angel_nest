class StartupsController < ApplicationController
  inherit_resources
  belongs_to :user, :optional => true
  include AngelNest::AutoUserScoping
end
