class Startup < ActiveRecord::Base
  include Features::Commentable
  include Features::Followable

  has_many :startup_users
  has_many :users, :through => :startup_users

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
end
