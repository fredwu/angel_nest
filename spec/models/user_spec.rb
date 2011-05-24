require 'spec_helper'

describe User do
  let :attrs do
    {
      :name     => 'John Doe',
      :email    => 'test@example.com',
      :password => 'password',
    }
  end

  describe "user creation" do
    it "creates a user given valid attributes" do
      User.new(attrs).should be_valid
    end

    it "requires a name" do
      User.new(attrs.merge(:name => '')).should_not be_valid
    end

    it "rejects a name that is too short" do
      User.new(attrs.merge(:name => 'a')).should_not be_valid
    end

    it "rejects a name that is too long" do
      User.new(attrs.merge(:name => 'a' * 100)).should_not be_valid
    end

    it "rejects an invalid email address" do
      User.new(attrs.merge(:email => 'invalid_email')).should_not be_valid
    end

    it "rejects duplicate email addresses" do
      User.create!(attrs)
      User.new(attrs).should_not be_valid
    end
  end

  describe "password validation" do
    def test_user_password(password, password_confirmation = nil)
      User.new(attrs.merge(
        :password              => password,
        :password_confirmation => (password || password_confirmation)
      )).should_not be_valid
    end

    it "requires a password" do
      test_user_password('')
    end

    it "requires a matching password confirmation" do
      test_user_password('a', 'b')
    end

    it "rejects a password that is too short" do
      test_user_password('a')
    end

    it "rejects a password that is too long" do
      test_user_password('a' * 50)
    end
  end

  context "user functions and associations" do
    subject { User.new }

    describe "user permissions" do
      it "responds to is_xxx?" do
        subject.respond_to?(:is_admin?).should be_true
        subject.respond_to?(:is_entrepreneur?).should be_true
        subject.respond_to?(:is_investor?).should be_true
      end
    end

    describe "user ventures" do
      it "responds to startups" do
        subject.association(:startups).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
      end

      it "responds to angels" do
        subject.association(:angels).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
      end

      it "responds to 'is_entrepreneur?'" do
        subject.is_entrepreneur?.should == false
      end

      it "responds to 'is_investor?'" do
        subject.is_investor?.should == false
      end

      it "adds startups" do
        subject.startups << Startup.new
        subject.is_entrepreneur?.should == true
      end

      it "adds angels" do
        subject.angels << Angel.new
        subject.is_investor?.should == true
      end
    end

    describe "user followers" do
      it "has user_followers (for quicker queries)" do
        # subject.association(:user_followers).should be_a(ActiveRecord::Associations::HasManyAssociation)
      end

      it "has followers" do
        subject.association(:followers).should be_a(ActiveRecord::Associations::HasAndBelongsToManyAssociation)
      end

      it "has followed users" do
        subject.association(:followings).should be_a(ActiveRecord::Associations::HasAndBelongsToManyAssociation)
      end
    end

    describe "user followers functionality" do
      subject { User.make! }
      let(:target_user) { User.make! }

      it "does not follow a user by default" do
        subject.is_following?(target_user).should == false
        target_user.is_followed_by?(subject).should == false
        subject.followings.count.should == 0
        target_user.followers.count.should == 0
      end

      it "follows another user" do
        subject.follow(target_user)
        subject.is_following?(target_user).should == true
        target_user.is_followed_by?(subject).should == true
        subject.followings.count.should == 1
        target_user.followers.count.should == 1
      end

      it "unfollows another user" do
        subject.follow(target_user)
        subject.unfollow(target_user)
        subject.is_following?(target_user).should == false
        target_user.is_followed_by?(subject).should == false
        subject.followings.count.should == 0
        target_user.followers.count.should == 0
      end
    end
  end
end
