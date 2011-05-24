class TargetFollower < ActiveRecord::Base
  belongs_to :user,     :foreign_key => :follower_id
  belongs_to :follower, :polymorphic => true
  belongs_to :target,   :polymorphic => true
end
