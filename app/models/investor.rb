class Investor < ActiveRecord::Base
  include Paramable

  has_and_belongs_to_many :proposals, :join_table => :proposal_for_investors
  belongs_to              :user

  validates :name,           :presence     => true,
                             :length       => { :within => 4..40 }
  validates :tagline,        :presence     => true,
                             :length       => { :within => 10..140 }
  validates :funds_to_offer, :presence     => true,
                             :numericality => true

  default_scope includes(:user)
end

class Array
  def for_auto_suggest
    map { |r| { :id => r.id, :name => r.name } }
  end
end
