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
         :validatable

  attr_readonly :messages_count

  attr_accessor   :login
  attr_accessible :login,
                  :username,
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

  def incoming_messages
    comments.private_only.topics
  end

  def outgoing_messages
    messages.on_users.private_only.topics
  end

  def inbox_messages
    incoming_messages.without_proposal.unarchived
  end

  def sent_messages
    outgoing_messages.without_proposal
  end

  def archived_messages
    incoming_messages.without_proposal.archived
  end

  def inbox_proposals
    incoming_messages.with_proposal.unarchived
  end

  def sent_proposals
    outgoing_messages.with_proposal
  end

  def archived_proposals
    incoming_messages.with_proposal.archived
  end

  def has_new_messages?
    inbox_messages.unread.any?
  end

  def has_new_proposals?
    inbox_proposals.unread.any?
  end

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

  def send_private_message(target_user, content, extras = {})
    messages.create!({
      :content     => content,
      :is_private  => true,
      :target_id   => target_user.id,
      :target_type => 'User'
    }.merge(extras), :as => :internal) && reload
  end

  def reply_private_message(topic, content, extras = {})
    messages.create!({
      :content     => content,
      :is_private  => true,
      :target_id   => topic.user.id,
      :target_type => 'User',
      :topic_id    => topic.id
    }.merge(extras), :as => :internal) && reload
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

  protected

  # Devise's support for login using the :login virtual attribute
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign_in-using-their-username-or-email-address
  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login      = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end

    def send_reset_password_instructions(attributes={})
      recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
      (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

      attributes = attributes.slice(*required_attributes)
      attributes.delete_if { |key, value| value.blank? }

      if attributes.size == required_attributes.size
        if attributes.has_key?(:login)
           login = attributes.delete(:login)
           record = find_record(login)
        else
          record = where(attributes).first
        end
      end

      unless record
        record = new

        required_attributes.each do |key|
          value = attributes[key]
          record.send("#{key}=", value)
          record.errors.add(key, value.present? ? error : :blank)
        end
      end
      record
    end

    def find_record(login)
      where(["username = :value OR email = :value", { :value => login }]).first
    end
  end

  private

  def email_nomarlisation
    self.email = email.strip.downcase
  end
end
