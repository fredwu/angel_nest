class Startup < ActiveRecord::Base
  include Features::IsGroup
  include Features::Followable
  include Features::Commentable

  mount_uploader :logo, LogoUploader
end
