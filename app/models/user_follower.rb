class UserFollower < ActiveRecord::Base
  belongs_to :followed,
             :class_name    => 'User',
             :foreign_key   => :user_id,
             :counter_cache => :followers_count

  belongs_to :followed_by,
             :class_name    => 'User',
             :foreign_key   => :follower_id,
             :counter_cache => :followings_count
end
