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

  describe "user permissions" do
    it "responds to is_xxx?" do
      User.new.respond_to?(:is_admin?).should be_true
      User.new.respond_to?(:is_entrepreneur?).should be_true
      User.new.respond_to?(:is_investor?).should be_true
    end
  end

  describe "user ventures" do
    it "has a venture" do
      User.new.association(:venture).should be_a(ActiveRecord::Associations::BelongsToPolymorphicAssociation)
    end
  end

  describe "user followers" do
    it "has followers" do
      User.new.association(:followers).should be_a(ActiveRecord::Associations::HasAndBelongsToManyAssociation)
    end

    it "has followed users" do
      User.new.association(:followings).should be_a(ActiveRecord::Associations::HasAndBelongsToManyAssociation)
    end
  end
end
