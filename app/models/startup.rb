class Startup < ActiveRecord::Base
  include Features::Commentable
  include Features::Followable

  mount_uploader :logo, LogoUploader

  has_many :startup_users
  has_many :users, :through => :startup_users
  has_many :proposals

  validates :name,              :presence     => true,
                                :uniqueness   => true,
                                :length       => { :within => 4..40 }
  validates :pitch,             :presence     => true,
                                :length       => { :within => 10..140 }
  validates :funds_to_raise,    :presence     => true,
                                :numericality => true
  validates :stage_identifier,  :presence     => true
  validates :market_identifier, :presence     => true
  validates :description,       :presence     => true

  scope :involved, where(['startup_users.role_identifier != ?', 'investor'])
  scope :invested, where(['startup_users.role_identifier = ?', 'investor'])

  def self.stages
    I18n.t 'startup.stage_identifiers'
  end

  def self.markets
    I18n.t 'startup.market_identifiers'
  end

  def stage
    I18n.t "startup.stage_identifiers.#{stage_identifier}"
  end

  def market
    I18n.t "startup.market_identifiers.#{market_identifier}"
  end

  def attach_user(user, role_identifier = :founder)
    startup_users.create(
      :user_id         => user.id,
      :role_identifier => role_identifier
    )
  end

  def detach_user(user)
    users.delete(user)
  end

  def create_proposal(content = {})
    proposal = proposals.new
    proposal.content = content
    proposal.save
    proposal
  end

  def submit_proposal(investors = [], content = {})
    proposal = create_proposal(content)
    proposal.update_attribute(:proposal_stage_identifier, 'submitted')
    proposal.investors = [investors].flatten
  end
end
