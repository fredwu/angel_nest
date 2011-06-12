require 'spec_helper'

describe Proposal do
  let(:proposal) { Proposal.make!(:pitch => 'Hello world') }

  it "reads the details" do
    proposal.pitch.should == 'Hello world'
  end

  it "edits the details" do
    proposal.pitch = 'Hello ruby'
    proposal.save
    Proposal.all.last.pitch.should == 'Hello ruby'
  end

  it "rejects invalid inuts" do
    proposal.penetration_rate = 101
    proposal.save.should raise_exception
  end
end
