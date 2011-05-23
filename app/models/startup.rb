class Startup < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_many :users, :as => :venture
end
