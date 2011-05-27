require 'spec_helper'

describe Startup do
  it_behaves_like "a group"

  subject do
    Startup.make({
      :stage_identifier  => 'market_pilot',
      :market_identifier => 'social_network',
    })
  end

  it "has a stage" do
    subject.stage.should == 'Market Pilot'
  end

  it "has a market" do
    subject.market.should == 'Social Network'
  end

  it "modifies stage on the fly" do
    subject.stage_identifier = 'has_profit'
    subject.stage.should == 'Has Profit'
  end

  it "modifies market on the fly" do
    subject.market_identifier = 'enterprise_software'
    subject.market.should == 'Enterprise Software'
  end

  it "errors out on invalid stage identifier" do
    subject.stage_identifier = 'invalid'
    subject.stage.should raise_exception
  end

  it "errors out on invalid market identifier" do
    subject.market_identifier = 'invalid'
    subject.market.should raise_exception
  end
end
