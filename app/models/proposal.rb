class Proposal < ActiveRecord::Base
  serialize :details

  has_and_belongs_to_many :investors, :join_table => :proposal_for_investors

  scope :draft,     where(:proposal_stage_identifier => 'draft')
  scope :submitted, where(:proposal_stage_identifier => 'submitted')

  before_create :default_proposal_stage_identifier

  class AttributesCollection
    include Virtus

    def method_missing(method, *args)
      nil
    end
  end

  class Details < AttributesCollection
    attribute :business,    Object
    attribute :market_1y,   Object
    attribute :market_5y,   Object
    attribute :competitors, Object
    attribute :investment,  Object

    class BusinessInfo < AttributesCollection
      attribute :new_business_model, Boolean
      attribute :new_product,        Boolean
      attribute :pitch,              String
      attribute :introduction,       String
    end

    class MarketInfo < AttributesCollection
      attribute :target_audience,            String
      attribute :per_capita_annual_spending, Integer
      attribute :number_of_users,            Integer
      attribute :market_cap,                 Integer
      attribute :penetration_rate,           Integer
      attribute :marketing_strategy,         String
      attribute :gross_profit_margin,        String
    end

    class CompetitorsInfo < AttributesCollection
      attribute :details,            String
      attribute :competitive_edges,  String
      attribute :competing_strategy, String
    end

    class InvestmentInfo < AttributesCollection
      attribute :amount,                Integer
      attribute :currency,              String
      attribute :equity_percentage,     Integer
      attribute :spending_plan,         String
      attribute :next_investment_round, Integer
    end
  end

  def submit(investors)
    self.investors = [investors].flatten
  end

  private

  def default_proposal_stage_identifier
    self.proposal_stage_identifier = 'draft'
  end
end
