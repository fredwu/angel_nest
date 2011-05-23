require 'spec_helper'

describe UserFollower do
  subject { UserFollower.new }

  it "doesn't have a primary key" do
    subject.attributes.include?('id').should be_false
  end

  it "references a user" do
    subject.respond_to?(:user_id).should be_true
  end

  it "references a user" do
    subject.respond_to?(:follower_id).should be_true
  end
end
