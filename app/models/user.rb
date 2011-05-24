class User < ActiveRecord::Base
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

  attr_readonly   :followers_count,
                  :followings_count
  attr_accessible :name,
                  :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  has_many :user_ventures

  has_many :angels,
           :through     => :user_ventures,
           :source      => :venture,
           :source_type => 'Angel'

  has_many :startups,
           :through     => :user_ventures,
           :source      => :venture,
           :source_type => 'Startup'

  has_many :target_followers, :foreign_key => :follower_id

  has_many :followings,
           :through     => :target_followers,
           :source      => :follower,
           :source_type => 'User'

  has_many :angels_followed,
           :through     => :target_followers,
           :source      => :target,
           :source_type => 'Angel'

  has_many :startups_followed,
           :through     => :target_followers,
           :source      => :target,
           :source_type => 'Startup'

  validates :name,     :presence     => true,
                       :length       => { :within => 2..40 }
  validates :email,    :presence     => true,
                       :format       => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                       :uniqueness   => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  def is_admin?
    !!is_admin
  end

  def is_entrepreneur?
    startups.present?
  end

  def is_investor?
    angels.present?
  end

  def follow(target)
    TargetFollower.create(
      :follower_id   => id,
      :follower_type => 'User',
      :target_id     => target.id,
      :target_type   => target.class.name
    )
  end

  def unfollow(target)
    TargetFollower.where(
      :follower_id   => id,
      :follower_type => 'User',
      :target_id     => target.id,
      :target_type   => target.class.name
    ).delete_all && reload
  end

  def is_following?(target)
    !!target_followers.where(:target_id => target.id, :target_type => target.class.name).first
  end

  def is_followed_by?(target)
    target.is_following?(self)
  end

  def followers
    follower_ids = TargetFollower.where(:target_id => id, :target_type => 'User').map(&:follower_id)
    User.where(:id => follower_ids)
  end
end
