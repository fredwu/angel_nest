require 'digest/md5'

class User < ActiveRecord::Base
  include Commentable,
          Followable

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

  has_many :messages, :order => 'created_at DESC'

  has_one  :investor_profile

  has_and_belongs_to_many :proposals, :join_table => :proposal_for_investors

  has_many :startup_users, :foreign_key => 'user_email', :primary_key => 'email'
  has_many :startups, :through => :startup_users

  has_many :target_followed,   :class_name => 'TargetFollower', :as => :follower
  has_many :users_followed,    :through => :target_followed, :source => :target, :source_type => 'User'
  has_many :startups_followed, :through => :target_followed, :source => :target, :source_type => 'Startup'

  validates :username, :presence     => true,
                       :uniqueness   => { :case_sensitive => false },
                       :length       => { :within => 4..20 },
                       :format       => { :with => /^[A-Za-z0-9_]+$/ }
  validates :name,     :presence     => true,
                       :length       => { :within => 4..30 }

  scope :new_users,     joins { [startup_users.outer, investor_profile.outer] }.where { (startup_users.user_email == nil) & (investor_profiles.user_id == nil) }
  scope :entrepreneurs, joins { startup_users }.where { startup_users.user_email != nil }
  scope :investors,     joins { investor_profile }.where { investor_profiles.user_id != nil }

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
    investor_profile.present?
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
    ) && reload unless target == self || target.nil?
  end

  def unfollow(target)
    target.target_followers.where(
      :follower_id   => id,
      :follower_type => 'User'
    ).first.try(:destroy) && reload unless target.nil?
  end

  def is_following?(target)
    return false if target.nil?
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

class Array
  def for_auto_suggest
    map { |r| { :id => r.id, :name => r.name } }
  end
end
