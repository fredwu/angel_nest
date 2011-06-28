class InvestorProfile < ActiveRecord::Base
  belongs_to :user

  validates :tagline,        :presence     => true,
                             :length       => { :within => 10..140 }
  validates :funds_to_offer, :presence     => true,
                             :numericality => true
end
