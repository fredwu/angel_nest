require 'spec_helper'

describe Proposal do
  let(:business_info) do
    Proposal::Details::BusinessInfo.new(
      :new_business_model => false,
      :new_product        => true,
      :pitch              => 'Hello world',
      :introduction       => ''
    )
  end

  let(:details)  { Proposal::Details.new(:business => business_info) }
  let(:proposal) { Proposal.all.last }

  before do
    Proposal.create(:details => details)
  end

  it "reads the details" do
    proposal.details.business.pitch.should == 'Hello world'
  end

  it "does not raise error when reading a non-existing attribute collection" do
    proposal.details.non_existing_attribute.should == nil
  end

  it "does not raise error when reading a non-existing attribute" do
    proposal.details.business.non_existing_attribute.should == nil
  end

  it "edits the details" do
    proposal.details.business.pitch = 'Hello ruby'
    proposal.save
    Proposal.all.last.details.business.pitch.should == 'Hello ruby'
  end
end
