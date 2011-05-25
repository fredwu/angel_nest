class Angel < ActiveRecord::Base
  include Features::Followable
  include Features::Commentable

  mount_uploader :logo, LogoUploader
end
