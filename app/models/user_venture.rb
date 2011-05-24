class UserVenture < ActiveRecord::Base
  belongs_to :user
  belongs_to :venture, :polymorphic => true
end
