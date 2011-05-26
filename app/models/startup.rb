class Startup < ActiveRecord::Base
  include Features::IsVenture
  include Features::Followable
  include Features::Commentable

  mount_uploader :logo, LogoUploader
end
