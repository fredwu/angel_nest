class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group, :polymorphic => true
end
