class Startup < ActiveRecord::Base
  include Features::Commentable
  include Features::Followable

  has_many :startup_users
  has_many :users, :through => :startup_users
  has_many :proposals

  mount_uploader :logo, LogoUploader

  def stage
    I18n.t "group.stage_identifiers.#{stage_identifier}"
  end

  def market
    I18n.t "group.market_identifiers.#{market_identifier}"
  end

  def attach_user(user, role_identifier = :follower)
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
