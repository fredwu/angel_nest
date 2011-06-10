class Proposal < ActiveRecord::Base
  has_and_belongs_to_many :investors, :join_table => :proposal_for_investors

  scope :draft,     where(:proposal_stage_identifier => 'draft')
  scope :submitted, where(:proposal_stage_identifier => 'submitted')

  before_create :default_proposal_stage_identifier

  def submit(investors)
    self.investors = [investors].flatten
  end

  private

  def default_proposal_stage_identifier
    self.proposal_stage_identifier = 'draft'
  end
end
