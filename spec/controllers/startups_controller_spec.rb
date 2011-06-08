require 'spec_helper'

describe StartupsController do
  let(:current_user) { User.make! }
  let(:user)         { User.make! }
  let(:user2)        { User.make! }

  before do
    2.times { Startup.make!.attach_user(current_user) }
    Startup.make!.attach_user(user)
  end

  context "index" do
    it "lists the non-scoped collection" do
      get :index

      @controller.send(:collection).count.should == 3
    end

    it "lists the scoped collection" do
      get :index, :user_id => user.id

      @controller.send(:collection).count.should == 1
    end

    it "lists the scoped empty collection" do
      get :index, :user_id => user2.id

      @controller.send(:collection).count.should == 0
    end

    it "lists the scoped collection for current user" do
      controller.stub(:current_user).and_return(current_user)

      get :my_index

      @controller.send(:collection).count.should == 2
    end
  end

  context "create" do
    subject { Startup.make }

    it "creates a startup with a founder user attached" do
      controller.stub(:current_user).and_return(current_user)

      post :create, :user_id => current_user.id, :startup => subject.attributes

      startup = Startup.last

      @controller.send(:resource).should == startup
      startup.users.first.should == current_user
      startup.users.count.should == 1
    end
  end
end
