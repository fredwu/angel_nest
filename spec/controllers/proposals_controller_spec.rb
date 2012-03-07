require 'spec_helper'

describe ProposalsController do
  include_context "inherited_resources"

  let(:current_user) { User.make! }
  let(:investor)     { User.make!(:investor_profile => InvestorProfile.make!) }
  let(:startup)      { Startup.make! }

  before do
    sign_in_user(current_user)
    startup.attach_user(current_user)
  end

  it "shows the edit page" do
    investors = [User.make!, User.make!]
    proposal  = Proposal.make!(
      :startup   => startup,
      :investors => investors
    )

    get :edit, :startup_id => startup.id,
               :id         => proposal.id

    response.should be_success
  end

  it "submits to an investor" do
    proposal = Proposal.make

    post :create, :startup_id => startup.id,
                  :proposal   => proposal.attributes,
                  :investors  => [investor.id],
                  :commit     => I18n.t('label.submit_proposal')

    startup.proposals.count.should == 1
    startup.proposals.last.pitch.should == proposal.pitch
    response.should redirect_to(startup_path(startup))
    flash[:success].should == I18n.t('message.proposal_submitted')
  end

  it "edits a draft proposal" do
    proposal  = Proposal.make!(:startup => startup)
    proposal2 = Proposal.make

    post :update, :startup_id => startup.id,
                  :id         => proposal.id,
                  :proposal   => {
                    :pitch => proposal2.pitch
                  },
                  :investors  => [investor.id],
                  :commit     => I18n.t('label.save_draft')

    startup.proposals.count.should == 1
    startup.proposals.last.pitch.should == proposal2.pitch
    response.should redirect_to(startup_path(startup))
    flash[:success].should == I18n.t('message.proposal_saved')
  end

  it "denies editing a submitted proposal" do
    proposal  = Proposal.make!(:startup => startup)
    proposal.update_attribute :proposal_stage_identifier, 'submitted'

    proposal2 = Proposal.make

    post :update, :startup_id => startup.id,
                  :id         => proposal.id,
                  :proposal   => {
                    :pitch => proposal2.pitch
                  },
                  :investors  => [investor.id],
                  :commit     => I18n.t('label.save_draft')

    startup.proposals.count.should == 1
    response.status.should == 403
    flash[:success].should == nil
  end

  context "access" do
    before do
      startup.detach_user(current_user)
      startup.attach_user(User.make!)
    end

    it "denies #edit" do
      get :edit, :startup_id => startup.id,
                 :id         => Proposal.make!(:startup => startup).id

      response.status.should == 403
    end
  end
end
