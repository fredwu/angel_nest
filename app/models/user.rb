require 'digest/md5'

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

  attr_readonly :messages_count

  attr_accessible :username,
                  :name,
                  :email,
                  :password,
                  :password_confirmation,
                  :remember_me

  validates :username, :presence     => true,
                       :uniqueness   => { :case_sensitive => false },
                       :length       => { :within => 4..20 },
                       :format       => { :with => /^[A-Za-z0-9_]+$/ }
  validates :name,     :presence     => true,
                       :length       => { :within => 4..30 }
  validates :email,    :presence     => true,
                       :uniqueness   => { :case_sensitive => false },
                       :format       => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  has_many :messages, :order => 'created_at DESC'

  has_one  :investor

  has_many :startup_users
  has_many :startups, :through => :startup_users

  has_many :target_followed,   :class_name => 'TargetFollower', :as => :follower
  has_many :users_followed,    :through => :target_followed, :source => :target, :source_type => 'User'
  has_many :startups_followed, :through => :target_followed, :source => :target, :source_type => 'Startup'

  scope :new_users,     includes(:startup_users, :investor).where('startup_users.user_id IS NULL').where('investors.user_id IS NULL')
  scope :entrepreneurs, joins(:startup_users).where('startup_users.user_id IS NOT NULL')
  scope :investors,     joins(:investor).where('investors.user_id IS NOT NULL')

  before_save :email_nomarlisation

  def is_admin?
    !!is_admin
  end

  def is_new_user?
    !is_entrepreneur? && !is_investor?
  end

  def is_entrepreneur?
    startups.present?
  end

  def is_investor?
    investor.present?
  end

  def avatar(size = 80)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}"
  end

  def send_private_message(target_user, content)
    messages.create(
      :content     => content,
      :target_id   => target_user.id,
      :target_type => 'User'
    ) && reload
  end

  def add_micro_post(content)
    unless content.blank?
      messages.create(:content => content) && reload
      true
    else
      false
    end
  end

  def micro_posts
    messages.micro_posts
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

  def followed_micro_posts
    Message.where(:target_id => nil, :user_id => users_followed_ids + [id]).default_order
  end

  private

  def email_nomarlisation
    self.email = email.strip.downcase
  end
end
