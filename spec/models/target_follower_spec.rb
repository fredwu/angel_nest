require 'spec_helper'

describe TargetFollower do
  subject { TargetFollower.new }

  it "doesn't have a primary key" do
    subject.attributes.include?('id').should be_false
  end

  it "references a target" do
    subject.respond_to?(:target_id).should be_true
    subject.respond_to?(:target_type).should be_true
  end

  it "references a follower" do
    subject.respond_to?(:follower_id).should be_true
  end
end
