class Startup < ActiveRecord::Base
  include Commentable,
          Followable,
          Paramable

  mount_uploader :logo, LogoUploader

  has_many :startup_users
  has_many :users,      :through => :startup_users
  has_many :members,    :through => :startup_users, :source => :user, :conditions => { 'startup_users.role_identifier' => 'member' }
  has_many :investors,  :through => :startup_users, :source => :user, :conditions => { 'startup_users.role_identifier' => 'investor' }
  has_many :advisors,   :through => :startup_users, :source => :user, :conditions => { 'startup_users.role_identifier' => 'advisor' }
  has_many :incubators, :through => :startup_users, :source => :user, :conditions => { 'startup_users.role_identifier' => 'incubator' }

  has_many :proposals

  validates :name,              :presence     => true,
                                :uniqueness   => true,
                                :length       => { :within => 4..40 }
  validates :pitch,             :presence     => true,
                                :length       => { :within => 10..140 }
  validates :funds_to_raise,    :presence     => true,
                                :numericality => true
  validates :stage_identifier,  :presence     => true,
                                :inclusion    => { :in => I18n.t('startup.stage_identifiers').keys.map(&:to_s) }
  validates :market_identifier, :presence     => true,
                                :inclusion    => { :in => I18n.t('startup.market_identifiers').keys.map(&:to_s) }
  validates :description,       :presence     => true

  scope :involved, where { startup_users.role_identifier != 'investor' }
  scope :invested, where { startup_users.role_identifier == 'investor' }

  def self.stages
    I18n.t 'startup.stage_identifiers'
  end

  def self.markets
    I18n.t 'startup.market_identifiers'
  end

  def self.roles
    I18n.t 'startup.role_identifiers'
  end

  def stage
    I18n.t "startup.stage_identifiers.#{stage_identifier}"
  end

  def market
    I18n.t "startup.market_identifiers.#{market_identifier}"
  end

  def logo_full
    logo? ? logo : 'startup_460x300.png'
  end

  def logo_thumb
    logo? ? logo.thumb : 'startup_153x100.png'
  end

  def attach_user(user, role_identifier = :member, member_title = '')
    startup_users.create(
      :user_email      => user.email,
      :role_identifier => role_identifier,
      :member_title    => member_title,
    )
  end

  def update_user(user, attributes = {})
    user = startup_users.where(
      :user_email => user.email,
    ).first
    user.update_attributes(attributes)
  end

  def detach_user(user)
    users.delete(user)
  end

  def founder
    members.first
  end

  def user_meta(user)
    startup_users.where(:user_email => user.email).first
  end

  def member_title(user)
    user_meta(user).member_title
  end

  def user_role(user)
    I18n.t "startup.role_identifiers.#{user_meta(user).role_identifier}"
  end

  def create_proposal(attributes = {})
    proposals.create(attributes)
  end

  def submit_proposal(investors = [], attributes = {})
    proposal = create_proposal(attributes)
    proposal.update_attribute(:proposal_stage_identifier, 'submitted')
    proposal.submit(investors)
    proposal
  end
end
