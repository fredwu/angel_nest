require 'spec_helper'

describe User do
  it_behaves_like "commentable"

  let :attrs do
    {
      :username => 'john_doe',
      :name     => 'John Doe',
      :email    => 'test@example.com',
      :password => 'password',
    }
  end

  let :attrs2 do
    {
      :username => 'john_doe_2',
      :name     => 'John Doe 2',
      :email    => 'test2@example.com',
      :password => 'password',
    }
  end

  describe "creation" do
    it "creates a user given valid attributes" do
      User.new(attrs).should be_valid
    end

    it "requires a username" do
      User.new(attrs.merge(:username => '')).should_not be_valid
    end

    it "rejects a username that contains illegal characters" do
      User.new(attrs.merge(:username => 'john_doe')).should be_valid
      User.new(attrs.merge(:username => 'john.doe')).should_not be_valid
      User.new(attrs.merge(:username => 'john-doe')).should_not be_valid
    end

    it "rejects duplicated usernames" do
      User.create!(attrs)
      User.new(attrs2.merge(:username => attrs[:username])).should_not be_valid
    end

    it "rejects duplicated case-insensitive usernames" do
      User.create!(attrs)
      User.new(attrs2.merge(:username => attrs[:username].upcase)).should_not be_valid
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

    it "rejects duplicated email addresses" do
      User.create!(attrs)
      User.new(attrs2.merge(:email => attrs[:email])).should_not be_valid
    end
  end

  describe "persistence" do
    it "normalises the email address" do
      user = User.new(attrs.merge(:email => 'TESTme@EXAMPLE.com'))
      user.save(:validate => false)

      user.email.should == 'testme@example.com'
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

  context "attributes" do
    subject { User.make! }

    it "has an avatar" do
      subject.avatar.should include('gravatar.com')
      subject.avatar(100).should include('s=100')
    end
  end

  context "functions and associations" do
    subject { User.make! }

    describe "permissions" do
      it "responds to is_xxx?" do
        subject.respond_to?(:is_admin?).should == true
        subject.respond_to?(:is_new_user?).should == true
        subject.respond_to?(:is_entrepreneur?).should == true
        subject.respond_to?(:is_investor?).should == true
      end

      it "is a new user" do
        subject.is_new_user?.should == true
      end

      it "is not an admin" do
        subject.is_admin?.should == false
      end

      it "is an admin" do
        user = User.make(:is_admin => true)
        user.is_admin?.should == true
      end
    end

    describe "user groups" do
      it "responds to startups" do
        subject.association(:startups).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
      end

      it "responds to investor" do
        subject.association(:investor).should be_a(ActiveRecord::Associations::HasOneAssociation)
      end

      it "responds to 'is_entrepreneur?'" do
        subject.is_entrepreneur?.should == false
      end

      it "responds to 'is_investor?'" do
        subject.is_investor?.should == false
      end

      it "adds startups" do
        subject.startups << Startup.make!
        subject.is_entrepreneur?.should == true
      end

      it "adds investor" do
        subject.investor = Investor.make!
        subject.is_investor?.should == true
      end

      it "finds entrepreneur users" do
        2.times { User.make! }
        subject.startups << Startup.make!
        User.new_users.count.should == 2
        User.entrepreneurs.count.should == 1
        User.investors.count.should == 0
      end

      it "finds investor users" do
        2.times { User.make! }
        subject.investor = Investor.make!
        User.new_users.count.should == 2
        User.entrepreneurs.count.should == 0
        User.investors.count.should == 1
      end
    end

    context "related resources" do
      subject       { User.make! }
      let(:user)    { User.make! }
      let(:user2)   { User.make! }
      let(:startup) { Startup.make! }

      describe "user followers" do
        it_behaves_like "followable"

        it "has followings" do
          subject.respond_to?(:followed).should be_true
        end

        describe "followed targets" do
          it "follows a nil target" do
            subject.follow(nil).should be_nil
          end

          it "unfollows a nil target" do
            subject.unfollow(nil).should be_nil
          end

          it "counts the number of followed targets" do
            subject.users_followed.count.should == 0
            subject.startups_followed.count.should == 0

            subject.follow(user)
            subject.users_followed.count.should == 1
            subject.startups_followed.count.should == 0

            subject.follow(startup)
            subject.users_followed.count.should == 1
            subject.startups_followed.count.should == 1

            subject.unfollow(user)
            subject.users_followed.count.should == 0
            subject.startups_followed.count.should == 1

            subject.unfollow(startup)
            subject.users_followed.count.should == 0
            subject.startups_followed.count.should == 0
          end
        end

        describe "followed micro posts" do
          it "sees micro posts from followed users, including self" do
            subject.follow(user)
            subject.follow(user2)

            time_travel_to(3.minute.ago) { user.add_micro_post('Hello world!') }
            time_travel_to(2.minute.ago) { user.add_micro_post('Hello ruby!') }
            time_travel_to(1.minute.ago) { user2.add_micro_post('Hello from user2!') }

            subject.add_micro_post('Hello from myself!')

            subject.followed_micro_posts.first.content.should == 'Hello from myself!'
            subject.followed_micro_posts.last.content.should == 'Hello world!'

            subject.followed_micro_posts.count.should == 4

            subject.unfollow(user)
            subject.followed_micro_posts.count.should == 2

            subject.unfollow(user2)
            subject.followed_micro_posts.count.should == 1
          end
        end
      end
    end
  end
end
