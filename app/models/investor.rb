class Investor < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  has_and_belongs_to_many :proposals, :join_table => :proposal_for_investors
  belongs_to              :user
end
