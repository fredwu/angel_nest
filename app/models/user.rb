class User < ActiveRecord::Base
  include Features::Commentable
  include Features::Followable

  devise :database_authenticatable,
         :token_authenticatable,
         :omniauthable,
         :confirmable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable

  attr_readonly :micro_posts_count

  attr_accessible :name,
                  :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  validates :name,     :presence     => true,
                       :length       => { :within => 2..40 }
  validates :email,    :presence     => true,
                       :format       => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                       :uniqueness   => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  has_many :posted_comments, :class_name => 'Comment'

  has_many :user_groups

  has_many :startups,  :through => :user_groups, :source => :group, :source_type => 'Startup'

  has_many :target_followed, :class_name => 'TargetFollower', :as => :follower

  has_many :users_followed,     :through => :target_followed, :source => :target, :source_type => 'User'
  has_many :startups_followed,  :through => :target_followed, :source => :target, :source_type => 'Startup'

  def is_admin?
    !!is_admin
  end

  def is_entrepreneur?
    startups.present?
  end

  def is_investor?
    false
  end

  def micro_posts
    posted_comments.on_users
  end

  def follow(target)
    target.target_followers.create(
      :follower_id   => id,
      :follower_type => 'User'
    ) && reload unless target == self
  end

  def unfollow(target)
    target.target_followers.where(
      :follower_id   => id,
      :follower_type => 'User'
    ).first.destroy && reload
  end

  def is_following?(target)
    !!target_followed.where(:target_id => target.id, :target_type => target.class.name).first
  end

  def followed
    users_followed + startups_followed
  end
end
