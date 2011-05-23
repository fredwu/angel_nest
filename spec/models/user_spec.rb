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
    it "requires a password" do
      User.new(attrs.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end

    it "requires a matching password confirmation" do
      User.new(attrs.merge(:password => 'a', :password_confirmation => 'b')).should_not be_valid
    end

    it "rejects a password that is too short" do
      password = 'a'
      User.new(attrs.merge(:password => password, :password_confirmation => password)).should_not be_valid
    end

    it "rejects a password that is too long" do
      password = 'a' * 50
      User.new(attrs.merge(:password => password, :password_confirmation => password)).should_not be_valid
    end
  end

  describe "user ventures" do
    it "has a venture" do
      User.new.association(:venture).class.should == ActiveRecord::Associations::BelongsToPolymorphicAssociation
    end
  end

  describe "user followers" do
    it "has followers" do
      User.new.association(:followers).class.should == ActiveRecord::Associations::HasAndBelongsToManyAssociation
    end

    it "has followed users" do
      User.new.association(:followings).class.should == ActiveRecord::Associations::HasAndBelongsToManyAssociation
    end
  end
end
