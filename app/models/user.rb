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

  attr_accessible :name,
                  :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  has_many :user_ventures

  has_many :startups,
           :through     => :user_ventures,
           :source      => :venture,
           :source_type => 'Startup'

  has_many :angels,
           :through     => :user_ventures,
           :source      => :venture,
           :source_type => 'Angel'

  has_and_belongs_to_many :followers,
                          :class_name              => 'User',
                          :join_table              => :user_followers,
                          :foreign_key             => :user_id,
                          :association_foreign_key => :follower_id

  has_and_belongs_to_many :followings,
                          :class_name              => 'User',
                          :join_table              => :user_followers,
                          :foreign_key             => :follower_id,
                          :association_foreign_key => :user_id

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

  def follow(target_user)
    target_user.followers << self
  end

  def unfollow(target_user)
    target_user.followers.delete(self)
  end

  def is_following?(target_user)
    !!UserFollower.where(
      :user_id     => target_user.id,
      :follower_id => id
    ).first
  end

  def is_followed_by?(target_user)
    target_user.is_following?(self)
  end
end
