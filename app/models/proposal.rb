class Proposal < ActiveRecord::Base
  has_and_belongs_to_many :investors, :join_table => :proposal_for_investors

  def content=(hash_content)
    self.json_content = hash_content.to_json
  end

  def content
    ActiveSupport::JSON.decode(json_content)
  end
end
