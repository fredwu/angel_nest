class Startup < ActiveRecord::Base
  include Features::Commentable
  include Features::Followable

  has_many :startup_users
  has_many :users, :through => :startup_users
  has_many :proposals

  mount_uploader :logo, LogoUploader

  def stage
    I18n.t "group.stage_identifiers.#{Settings.group.startup.stage_identifiers[stage_identifier]}"
  end

  def market
    I18n.t "group.market_identifiers.#{Settings.group.startup.market_identifiers[market_identifier]}"
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

  def new_proposal(investors = [], content = {})
    proposal = proposals.create({
      :proposal_stage_identifier => Settings.group.startup.proposal_stage_identifiers['submission'],
      :json_content              => content.to_json,
    })

    proposal.investors = [investors].flatten
  end
end
