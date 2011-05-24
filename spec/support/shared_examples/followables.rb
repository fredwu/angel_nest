shared_examples "followables" do
  subject      { User.make! }
  let(:target) { described_class.make! }

  it "does not follow a target by default" do
    subject.is_following?(target).should == false
    target.is_followed_by?(subject).should == false
    subject.followings.count.should == 0
    target.followers.count.should == 0
  end

  it "follows a target" do
    subject.follow(target)
    subject.is_following?(target).should == true
    target.is_followed_by?(subject).should == true
    subject.followings.count.should == 1
    target.followers.count.should == 1
  end

  it "unfollows a target" do
    subject.follow(target)
    subject.unfollow(target)
    subject.is_following?(target).should == false
    target.is_followed_by?(subject).should == false
    subject.followings.count.should == 0
    target.followers.count.should == 0
  end
end