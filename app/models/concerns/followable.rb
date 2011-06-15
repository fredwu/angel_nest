module Followable
  extend ActiveSupport::Concern

  included do
    attr_readonly :followed_count,
                  :followers_count

    has_many :target_followers, :as => :target

    has_many :followers,
             :through     => :target_followers,
             :source      => :follower,
             :source_type => 'User'
  end

  def is_followed_by?(target)
    if target
      target.is_following?(self)
    else
      false
    end
  end
end
