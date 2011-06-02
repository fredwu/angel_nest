class StartupsController < ApplicationController
  inherit_resources
  include AngelNest::AutoUserScoping
end
