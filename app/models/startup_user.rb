class StartupUser < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'user_email', :primary_key => 'email'
  belongs_to :startup

  attr_accessible :user_email,
                  :role_identifier,
                  :member_title
end
