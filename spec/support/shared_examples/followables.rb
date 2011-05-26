shared_examples "followables" do
  subject       { User.make! }
  let(:target)  { described_class.make! }
  let(:target2) { described_class.make! }

  it "has followers" do
    subject.association(:followers).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
  end

  it "does not allow alteration on counter cache fields" do
    subject.followed_count = 10
    subject.followers_count = 10
    subject.save!
    subject.reload

    subject.followed_count.should == 0
    subject.followers_count.should == 0
  end

  it "does not follow a target by default" do
    subject.is_following?(target).should == false
    target.is_followed_by?(subject).should == false

    subject.followed.count.should == 0
    target.followers.count.should == 0

    subject.followed_count == 0
    target.followers_count == 0
  end

  it "follows a target" do
    subject.follow(target)

    subject.is_following?(target).should == true
    subject.is_following?(target2).should == false

    target.is_followed_by?(subject).should == true
    target2.is_followed_by?(subject).should == false

    subject.followed.count.should == 1
    target.followers.count.should == 1
    target2.followers.count.should == 0

    subject.followed_count == 1
    target.followers_count == 1
    target2.followers_count == 1

    subject.follow(target2)

    subject.followed.count.should == 2
    target.followers.count.should == 1
    target2.followers.count.should == 1

    subject.followed_count == 2
    target.followers_count == 1
    target2.followers_count == 1
  end

  it "unfollows a target" do
    subject.follow(target)
    subject.follow(target2)
    subject.unfollow(target)

    subject.is_following?(target).should == false
    subject.is_following?(target2).should == true

    target.is_followed_by?(subject).should == false
    target2.is_followed_by?(subject).should == true

    subject.followed.count.should == 1
    target.followers.count.should == 0
    target2.followers.count.should == 1

    subject.followed_count == 1
    target.followers_count == 0
    target2.followers_count == 1

    subject.unfollow(target2)

    subject.followed.count.should == 0
    target.followers.count.should == 0
    target2.followers.count.should == 0

    subject.followed_count == 0
    target.followers_count == 0
    target2.followers_count == 0
  end
end