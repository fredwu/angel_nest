class StartupPhoto < ActiveRecord::Base
  mount_uploader :photo, StartupPhotoUploader

  belongs_to :startup
end
