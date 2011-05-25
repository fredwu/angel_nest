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

  attr_readonly :followed_count,
                :followers_count

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

  has_many :followed,
           :through     => :target_followers,
           :source      => :follower,
           :source_type => 'User'

  scope :users_followed,    where(:target_followers => { :target_type => 'User' })
  scope :angels_followed,   where(:target_followers => { :target_type => 'Angel' })
  scope :startups_followed, where(:target_followers => { :target_type => 'Startup' })

  def users_followed;    followed.users_followed    end
  def angels_followed;   followed.angels_followed   end
  def startups_followed; followed.startups_followed end

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
    ) && reload unless target == self
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
