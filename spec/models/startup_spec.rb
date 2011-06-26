require 'spec_helper'

describe Startup do
  it_behaves_like "commentable"
  it_behaves_like "followable"
  it_behaves_like "paramable"

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

      expect { subject.save! }.to raise_exception
    end

    it "errors out on invalid market identifier" do
      subject.market_identifier = 'invalid'

      expect { subject.save! }.to raise_exception
    end
  end

  describe "user roles" do
    let(:member) { User.make! }
    let(:user)   { User.make! }

    before do
      subject.attach_user(member, :member)
    end

    it "has all the roles listed" do
      Startup.roles.should == I18n.t('startup.role_identifiers')
    end

    it "has a founding user and role" do
      subject.users.count.should == 1
      subject.users.first.should == member
      subject.startup_users.first.role_identifier.should == 'member'
    end

    it "attaches a user" do
      subject.attach_user(user, :advisor)

      subject.users.count.should == 2
      subject.users.last.should == user
    end

    it "detaches a user" do
      subject.attach_user(user)
      subject.detach_user(user)

      subject.users.count.should == 1
      subject.users.last.should == member
      User.last.should == user
    end
  end

  describe "user involvement and investment" do
    let(:user) { User.make! }

    it "recognises user involvement" do
      subject.attach_user(user, :member, 'CEO')

      user.startups.involved.count.should == 1
      user.startups.invested.count.should == 0
      subject.members.first.should == user
    end

    it "recognises user investment" do
      subject.attach_user(user, :investor)

      user.startups.involved.count.should == 0
      user.startups.invested.count.should == 1
      subject.investors.first.should == user
    end

    it "recognises the founder user" do
      User.make!
      subject.attach_user(user)
      subject.attach_user(User.last)

      subject.founder.should == user
    end

    it "attaches a user by email" do
      subject.attach_user('test@example.com')

      subject.startup_users.last.user_email.should == 'test@example.com'
    end

    it "doesn't attache the same user twice, if roles are the same" do
      subject.attach_user(user, :advisor)
      subject.attach_user(user, :advisor)

      subject.all_users.count.should == 1
    end

    it "attaches the same user with different roles" do
      subject.attach_user(user, :advisor)
      subject.attach_user(user, :investor)

      subject.all_users.count.should == 2
    end

    it "confirms the attached user" do
      subject.attach_user(user)

      subject.user_meta(user).confirmed.should == false

      subject.confirm_user(user)

      subject.user_meta(user).confirmed.should == true
    end

    it "updates the attached user" do
      subject.attach_user(user, :member, 'CEO')
      subject.update_user(user, :member, { :member_title => 'CTO' })

      subject.user_meta(user).member_title.should == 'CTO'
    end

    it "detaches a user" do
      subject.attach_user(user, :advisor)
      subject.attach_user(user, :investor)
      subject.detach_user(user, :advisor)

      subject.user_meta(user, :investor).role_identifier.should == 'investor'
      subject.all_users.count.should == 1
    end

    it "recognises user meta" do
      subject.attach_user(user, :member, 'CEO')
      subject.user_meta(user).member_title.should == 'CEO'
      subject.member_title(user).should == 'CEO'
      subject.user_role(user).should == 'Member'
    end
  end

  describe "proposals" do
    let(:proposal)  { Proposal.make }
    let(:investor1) { Investor.make! }
    let(:investor2) { Investor.make! }

    it "creates a draft proposal" do
      subject.create_proposal(proposal.attributes)

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 1
      subject.proposals.submitted.count.should == 0
      subject.proposals.first.proposal_stage_identifier.should == 'draft'
    end

    it "submits proposal to no investor" do
      subject.submit_proposal([], proposal.attributes)

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 1
      subject.proposals.submitted.count.should == 0
    end

    it "submits proposal to one investor" do
      subject.submit_proposal(investor1, proposal.attributes, 'submitted')

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 0
      subject.proposals.submitted.count.should == 1
      investor1.proposals.count.should == 1
      subject.proposals.first.proposal_stage_identifier.should == 'submitted'
    end

    it "submits proposal to many investors" do
      subject.submit_proposal([investor1, investor2], proposal.attributes, 'submitted')

      subject.proposals.count.should == 1
      subject.proposals.draft.count.should == 0
      subject.proposals.submitted.count.should == 1
      investor1.proposals.count.should == 1
      investor2.proposals.count.should == 1
    end

    it "edits a proposal" do
      subject.submit_proposal(investor1, proposal.attributes)
      subject.update_proposal(Proposal.last, investor2, Proposal.make(:pitch => 'Hello world').attributes)

      Proposal.last.pitch.should == 'Hello world'
      Proposal.last.investors.count.should == 1
      Proposal.last.investors.first.should == investor2
    end

    it "preserves proposal details structure" do
      proposal_attributes = proposal.attributes.merge(:pitch => 'Hello world')
      subject.submit_proposal(investor1, proposal_attributes)

      Proposal.last.pitch.should == 'Hello world'
    end
  end

  describe "logo" do
    let(:uploader) { LogoUploader.new(subject, :logo) }

    it "does not save invalid file types" do
      expect { uploader.store!(load_file('file.gif')) }.to raise_exception(CarrierWave::IntegrityError)
    end

    it "reads the saved logo" do
      uploader.store!(load_file('file.jpg'))
      uploader.to_s.should match(/startup.*file\.jpg/)
      uploader.thumb.to_s.should match(/startup.*file\.jpg/)
    end

    it "reads the default logo" do
      subject.logo_full.should == 'startup_460x300.png'
    end

    it "reads the default thumb logo" do
      subject.logo_thumb.should == 'startup_153x100.png'
    end
  end
end
