require 'spec_helper'

describe Proposal do
  let(:proposal) { Proposal.make!(:pitch => 'Hello world') }

  it "identifies the stage of the proposal" do
    proposal.stage.should == 'Draft'
  end

  it "reads the details" do
    proposal.pitch.should == 'Hello world'
  end

  it "edits the details" do
    proposal.pitch = 'Hello ruby'
    proposal.save
    proposal.reload
    proposal.pitch.should == 'Hello ruby'
  end

  it "is submitted" do
    investor = User.make!(:investor_profile => InvestorProfile.make!)
    proposal.submit(investor)
    proposal.reload
    proposal.investors.last == investor
  end

  it "rejects invalid inuts" do
    proposal.one_year_penetration_rate = 101
    expect { proposal.save! }.to raise_exception
  end
end
