require 'spec_helper'

describe StartupUser do
  it "belongs to a user" do
    described_class.new.association(:user).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end

  it "belongs to a startup" do
    described_class.new.association(:startup).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end
end
