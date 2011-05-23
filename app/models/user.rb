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

  belongs_to :venture, :polymorphic => true

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

  def is_startup?
    venture.class == Startup
  end

  def is_angel?
    venture.class == Angel
  end
end
