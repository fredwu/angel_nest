require 'spec_helper'

describe Startup do
  it_behaves_like "commentables"
  it_behaves_like "followables"

  subject do
    Startup.make!({
      :stage_identifier  => 'market_pilot',
      :market_identifier => 'social_network',
    })
  end

  describe "startup creation" do
    it "rejects duplicated names" do
      Startup.make!(:name => 'My Startup')
      Startup.make(:name => 'My Startup').should_not be_valid
    end
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
    let(:founder)   { User.make! }
    let(:user)      { User.make! }

    before do
      subject.attach_user(founder, :founder)
    end

    it "has a founding user and role" do
      subject.users.count.should == 1
      subject.users.first.should == founder
      subject.startup_users.first.role_identifier.should == 'founder'
    end

    it "attaches a user" do
      subject.attach_user(user, :advisor)

      subject.users.count.should == 2
      subject.users.all.last.should == user
    end

    it "detaches a user" do
      subject.attach_user(user)
      subject.detach_user(user)

      subject.users.count.should == 1
      subject.users.all.last.should == founder
      User.all.last.should == user
    end
  end

  describe "user involvement and investment" do
    let(:user) { User.make! }

    it "recognises user involvement" do
      subject.attach_user(user, :founder)

      user.startups.involved.count.should == 1
      user.startups.invested.count.should == 0
    end

    it "recognises user investment" do
      subject.attach_user(user, :investor)

      user.startups.involved.count.should == 0
      user.startups.invested.count.should == 1
    end
  end

  describe "proposals" do
    let(:investor1)      { Investor.make! }
    let(:investor2)      { Investor.make! }

    it "creates a draft proposal" do
      subject.create_proposal({ 'hello' => 'world' })

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 1
      subject.proposals.submitted.count.should == 0
      subject.proposals.first.proposal_stage_identifier.should == 'draft'
    end

    it "submits proposal to one investor" do
      subject.submit_proposal(investor1, { 'hello' => 'world' })

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 0
      subject.proposals.submitted.count.should == 1
      investor1.proposals.count.should == 1
      subject.proposals.first.proposal_stage_identifier.should == 'submitted'
    end

    it "submits proposal to many investors" do
      subject.submit_proposal([investor1, investor2], { 'hello' => 'world' })

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 0
      subject.proposals.submitted.count.should == 1
      investor1.proposals.count.should == 1
      investor2.proposals.count.should == 1
    end

    it "preserves proposal content structure" do
      subject.submit_proposal(investor1, { 'hello' => 'world' })

      subject.proposals.first.content['hello'].should == 'world'
    end
  end
end
