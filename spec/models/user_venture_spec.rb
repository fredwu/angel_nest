require 'spec_helper'

describe UserVenture do
  it "belongs to a user" do
    UserVenture.new.association(:user).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end

  it "belongs to a venture" do
    UserVenture.new.association(:venture).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end
end
