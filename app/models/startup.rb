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

  def logo_avatar
    logo? ? logo.avatar : 'startup_50x50.png'
  end

  def invite_or_attach_user(role_identifier, attributes)
    user = User.find_by_email(attributes[:email]) || attributes[:email] # && TODO: send an invitation email

    attach_user(user, role_identifier, attributes[:member_title])
  end

  def attach_user(user, role_identifier = :member, member_title = '')
    startup_users.create(
      :user_email      => (user.try(:email) || user),
      :role_identifier => role_identifier.to_s,
      :member_title    => member_title,
    ) unless user_meta(user, role_identifier)
  end

  def confirm_user(user, role_identifier = :member)
    user_meta(user, role_identifier).update_attribute(:confirmed, true)
  end

  def update_user(user, role_identifier = :member, attributes = {})
    user_meta(user, role_identifier).update_attributes(attributes)
  end

  def detach_user(user, role_identifier = :member)
    user_meta(user, role_identifier).destroy
  end

  def founder
    members.first
  end

  def user_meta(user, role_identifier = :member)
    startup_users.where(
      :user_email      => (user.try(:email) || user),
      :role_identifier => role_identifier.to_s
    ).first
  end

  def member_title(user, role_identifier = :member)
    user_meta(user, role_identifier).member_title
  end

  def user_role(user)
    I18n.t "startup.role_identifiers.#{user_meta(user).role_identifier}"
  end

  def create_proposal(attributes = {})
    proposals.create(attributes)
  end

  def submit_proposal(investors = [], attributes = {}, stage = 'draft')
    proposal = create_proposal(attributes)
    update_and_submit_proposal(proposal, investors, attributes, stage)
  end

  def update_proposal(proposal, investors = [], attributes = {}, stage = 'draft')
    proposal.update_attributes(attributes)
    update_and_submit_proposal(proposal, investors, attributes, stage)
  end

  def all_users
    members + investors + advisors + incubators
  end

  private

  def update_and_submit_proposal(proposal, investors, attributes, stage)
    proposal.update_attribute(:proposal_stage_identifier, stage)
    proposal.submit(investors)
    proposal
  end
end
