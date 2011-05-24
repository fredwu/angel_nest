module Followable
  def self.included(model)
    model.class_eval do
      has_many :target_followers, :as => :target

      has_many :followers,
               :through     => :target_followers,
               :source      => :follower,
               :source_type => 'User'
    end
  end

  def is_followed_by?(target)
    target.is_following?(self)
  end
end
