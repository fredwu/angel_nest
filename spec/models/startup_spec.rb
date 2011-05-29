require 'spec_helper'

describe Startup do
  it_behaves_like "commentables"
  it_behaves_like "followables"

  subject do
    Startup.make({
      :stage_identifier  => 'market_pilot',
      :market_identifier => 'social_network',
    })
  end

  describe "associations" do
    it "has users" do
      subject.association(:users).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
      subject.association(:startup_users).should be_a(ActiveRecord::Associations::HasManyAssociation)
    end
  end

  describe "stage and market" do
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

  describe "user roles" do
    subject       { Startup.make! }
    let(:founder) { User.make! }
    let(:user)    { User.make! }

    before do
      subject.attach_user(founder, :founder)
    end

    it "has a founding user and role" do
      subject.users.count.should == 1
      subject.users.first == founder
      subject.startup_users.first.role_identifier == 'founder'
    end

    it "attaches a user" do
      subject.attach_user(user, :advisor)
      subject.users.count.should == 2
      subject.users.last == user
    end

    it "detaches a user" do
      subject.attach_user(user)
      subject.detach_user(user)
      subject.users.count.should == 1
      subject.users.last == founder
      User.last.should == user
    end
  end
end
