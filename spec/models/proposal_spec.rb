require 'spec_helper'

describe Proposal do
  it "saves and retrieves content" do
    proposal = Proposal.create(:content => { 'hello' => 'world' })

    proposal.content.should == { 'hello' => 'world' }
  end
end
