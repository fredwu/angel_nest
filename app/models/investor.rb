class Investor < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  belongs_to :user
end
