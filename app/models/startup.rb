class Startup < ActiveRecord::Base
  include Features::IsGroup
  include Features::Followable
  include Features::Commentable

  mount_uploader :logo, LogoUploader

  def stage
    I18n.t "group.stage_identifiers.#{Settings.group.startup.stage_identifiers[stage_identifier]}"
  end

  def market
    I18n.t "group.market_identifiers.#{Settings.group.startup.market_identifiers[market_identifier]}"
  end
end
