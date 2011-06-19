class Proposal < ActiveRecord::Base
  belongs_to              :startup
  has_and_belongs_to_many :investors, :join_table => :proposal_for_investors

  validates :pitch,                      :presence     => true,
                                         :length       => { :within => 10..140 }
  validates :introduction,               :presence     => true,
                                         :length       => { :within => 10..300 }
  validates :target_audience,            :presence     => true,
                                         :length       => { :within => 10..300 }
  validates :per_capita_annual_spending, :numericality => true
  validates :number_of_users,            :numericality => true
  validates :market_cap,                 :presence     => true,
                                         :numericality => true
  validates :penetration_rate,           :presence     => true,
                                         :numericality => { :less_than_or_equal_to  => 100 }
  validates :marketing_strategy,         :length       => { :within => 10..400 }
  validates :gross_profit_margin,        :presence     => true,
                                         :numericality => true
  validates :competitors_details,        :presence     => true,
                                         :length       => { :within => 10..400 }
  validates :competitive_edges,          :presence     => true,
                                         :length       => { :within => 10..400 }
  validates :competing_strategy,         :presence     => true,
                                         :length       => { :within => 10..400 }
  validates :investment_amount,          :presence     => true,
                                         :numericality => true
  validates :investment_currency,        :presence     => true,
                                         :inclusion    => { :in => Settings.currencies }
  validates :equity_percentage,          :presence     => true,
                                         :numericality => { :less_than_or_equal_to => 100 }
  validates :spending_plan,              :presence     => true,
                                         :length       => { :within => 10..400 }
  validates :next_investment_round,      :presence     => true,
                                         :numericality => true

  scope :draft,     where(:proposal_stage_identifier => 'draft')
  scope :submitted, where(:proposal_stage_identifier => 'submitted')

  before_create :default_proposal_stage_identifier

  def self.stages
    I18n.t 'startup.proposal_stage_identifiers'
  end

  def stage
    I18n.t "startup.proposal_stage_identifiers.#{proposal_stage_identifier}"
  end

  def submit(investors)
    self.investors = [investors].flatten
    self.proposal_stage_identifier = 'submitted'
    self.save
  end

  private

  def default_proposal_stage_identifier
    self.proposal_stage_identifier = 'draft'
  end
end
