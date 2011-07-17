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

  context "startup" do
    let(:proposal)  { Proposal.make }
    let(:startup)   { Startup.make! }
    let(:founder)   { User.make! }
    let(:investor1) { User.make!(:investor_profile => InvestorProfile.make!) }
    let(:investor2) { User.make!(:investor_profile => InvestorProfile.make!) }

    before do
      startup.attach_user(founder, :member)
    end

    it "returns the proposal itself" do
      startup.create_proposal([], proposal.attributes).should == Proposal.last
    end

    it "submits proposal to no investor" do
      startup.create_proposal([], proposal.attributes)

      startup.proposals.count.should == 1
      startup.proposals.draft.count.should == 1
      startup.proposals.submitted.count.should == 0
    end

    it "submits proposal to one investor" do
      startup.create_proposal(investor1, proposal.attributes, 'submitted')

      startup.proposals.count.should == 1
      startup.proposals.draft.count.should == 0
      startup.proposals.submitted.count.should == 1
      startup.founder.sent_proposals.count.should == 1
      investor1.has_new_proposals?.should == true
      investor1.proposals.count.should == 1
      investor1.inbox_proposals.count.should == 1
      startup.proposals.first.proposal_stage_identifier.should == 'submitted'
      startup.founder.sent_proposals.first.content.should == I18n.t('text.default_text_for_proposal_review')
      Message.last.is_with_proposal?.should == true
      Message.last.is_without_proposal?.should == false
    end

    it "submits proposal to many investors" do
      startup.create_proposal([investor1, investor2], proposal.attributes, 'submitted', 'Hey man!')

      startup.proposals.count.should == 1
      startup.proposals.draft.count.should == 0
      startup.proposals.submitted.count.should == 1
      startup.founder.sent_proposals.count.should == 2
      investor1.proposals.count.should == 1
      investor1.inbox_proposals.count.should == 1
      investor1.inbox_messages.count.should == 0
      investor2.proposals.count.should == 1
      investor2.inbox_proposals.count.should == 1
      investor2.inbox_messages.count.should == 0
      startup.founder.sent_proposals.first.content.should == 'Hey man!'
    end

    it "edits a proposal" do
      startup.create_proposal(investor1, proposal.attributes)
      startup.update_proposal(Proposal.last, investor2, Proposal.make(:pitch => 'Hello world').attributes)

      Proposal.last.pitch.should == 'Hello world'
      Proposal.last.investors.count.should == 1
      Proposal.last.investors.first.should == investor2
      investor1.proposals.count.should == 0
      investor2.proposals.count.should == 1
      investor1.inbox_messages.count.should == 0
      investor2.inbox_messages.count.should == 0
    end

    it "edits and submits a proposal" do
      startup.create_proposal(investor1, proposal.attributes)
      startup.update_proposal(Proposal.last, investor2, Proposal.make(:pitch => 'Hello world').attributes, 'submitted')

      Proposal.last.pitch.should == 'Hello world'
      Proposal.last.investors.count.should == 1
      Proposal.last.investors.first.should == investor2
      investor1.proposals.count.should == 0
      investor2.proposals.count.should == 1
      investor1.inbox_messages.count.should == 0
      investor2.inbox_messages.count.should == 0
    end

    it "archives a proposal message" do
      startup.create_proposal(investor1, proposal.attributes, 'submitted')

      investor1.inbox_proposals.count.should == 1
      investor1.archived_proposals.count.should == 0
      investor1.inbox_messages.count.should == 0
      investor1.archived_messages.count.should == 0

      investor1.inbox_proposals.first.mark_as_archived!

      investor1.inbox_proposals.count.should == 0
      investor1.archived_proposals.count.should == 1
      investor1.inbox_messages.count.should == 0
      investor1.archived_messages.count.should == 0
    end

    it "preserves proposal details structure" do
      proposal_attributes = proposal.attributes.merge(:pitch => 'Hello world')
      startup.create_proposal(investor1, proposal_attributes)

      Proposal.last.pitch.should == 'Hello world'
    end
  end
end
