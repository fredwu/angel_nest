require 'spec_helper'

describe UserGroup do
  it "belongs to a user" do
    UserGroup.new.association(:user).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end

  it "belongs to a group" do
    UserGroup.new.association(:group).should be_a(ActiveRecord::Associations::BelongsToAssociation)
  end
end
