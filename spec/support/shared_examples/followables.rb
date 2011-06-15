shared_examples "followables" do
  let(:user)    { User.make! }
  let(:target)  { described_class.make! }
  let(:target2) { described_class.make! }

  it "has followers" do
    user.association(:followers).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
  end

  it "does not allow alteration on counter cache fields" do
    user.followed_count = 10
    user.followers_count = 10
    user.save!
    user.reload

    user.followed_count.should == 0
    user.followers_count.should == 0
  end

  it "does not follow a target by default" do
    user.is_following?(target).should == false
    target.is_followed_by?(user).should == false

    user.followed.count.should == 0
    target.followers.count.should == 0

    user.followed_count == 0
    target.followers_count == 0
  end

  it "follows a target" do
    user.follow(target)

    user.is_following?(target).should == true
    user.is_following?(target2).should == false

    target.is_followed_by?(user).should == true
    target2.is_followed_by?(user).should == false

    user.followed.count.should == 1
    target.followers.count.should == 1
    target2.followers.count.should == 0

    user.followed_count == 1
    target.followers_count == 1
    target2.followers_count == 1

    user.follow(target2)

    user.followed.count.should == 2
    target.followers.count.should == 1
    target2.followers.count.should == 1

    user.followed_count == 2
    target.followers_count == 1
    target2.followers_count == 1
  end

  it "unfollows a target" do
    user.follow(target)
    user.follow(target2)
    user.unfollow(target)

    user.is_following?(target).should == false
    user.is_following?(target2).should == true

    target.is_followed_by?(user).should == false
    target2.is_followed_by?(user).should == true

    user.followed.count.should == 1
    target.followers.count.should == 0
    target2.followers.count.should == 1

    user.followed_count == 1
    target.followers_count == 0
    target2.followers_count == 1

    user.unfollow(target2)

    user.followed.count.should == 0
    target.followers.count.should == 0
    target2.followers.count.should == 0

    user.followed_count == 0
    target.followers_count == 0
    target2.followers_count == 0
  end

  it "is following a nil target" do
    user.is_following?(nil).should == false
  end

  it "is followed by a nil user" do
    target.is_followed_by?(nil).should == false
  end
end