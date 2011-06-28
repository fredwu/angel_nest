require 'spec_helper'

describe InvestorProfile do
  it "has #for_auto_suggest" do
    investor = User.make!(:investor_profile => InvestorProfile.make!)
    [investor].for_auto_suggest.should be_a(Array)
    [investor].for_auto_suggest.should == [{ :id => investor.id, :name => investor.name }]
  end
end
