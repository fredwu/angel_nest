require 'spec_helper'

describe StartupsController do
  it_behaves_like "ensure_ownership"
  include_context "inherited_resources"

  authenticates_gets
  authenticates_posts

  let(:startup)      { Startup.make! }
  let(:current_user) { User.make! }
  let(:user)         { User.make! }
  let(:user2)        { User.make! }

  context "index" do
    before do
      2.times { Startup.make!.attach_user(current_user) }
      Startup.make!.attach_user(user)
      sign_in_user(current_user)
    end

    it "lists the non-scoped collection" do
      get :index

      collection.count.should == 3
      response.should be_success
    end

    it "shows pagination" do
      get :index, :page => 99

      collection.should == Startup.page(99)
      response.should be_success
    end

    it "lists the scoped collection" do
      get :index, :user_id => user.id

      collection.count.should == 1
    end

    it "lists the scoped empty collection" do
      get :index, :user_id => user2.id

      collection.count.should == 0
    end

    it "shows pagination for the scoped collection" do
      get :index, :user_id => user.id, :page => 99

      collection.should == user.startups.page(99)
      response.should be_success
    end
  end

  context "CRUD" do
    before do
      startup.attach_user(current_user)
      startup.attach_user(user)
      sign_in_user(current_user)
    end

    hides_sidebar :get, :show
    hides_sidebar :get, :edit

    it "creates a startup profile with a member user attached" do
      post :create, :user_id => current_user.id,
                    :startup => Startup.make.attributes

      startup = Startup.last

      resource.should == startup
      startup.users.first.should == current_user
      startup.users.count.should == 1
      startup.user_meta(current_user).member_title.should == 'Founder'
      startup.user_meta(current_user).confirmed.should == true
    end

    it "edits a startup profile" do
      post :update, :user_id => current_user.id,
                    :id      => startup.id,
                    :startup => startup.attributes.merge(:name => 'Edited Name')

      startup.reload

      resource.should == startup
      startup.name.should == 'Edited Name'
    end

    context "ajax partials" do
      it "shows profile details" do
        get :profile_details, :id => startup.id

        resource.should == startup
      end

      it "shows profile team" do
        get :profile_team, :id => startup.id

        resource.should == startup
      end
    end

    context "users" do
      it "attaches a user" do
        post :attach_user, :id              => startup.id,
                           :role_identifier => 'advisor',
                           :attributes      => {
                                                 :name         => 'John Doe',
                                                 :member_title => 'Awesome Advisor',
                                                 :email        => 'test@example.com',
                                               }

        startup.user_meta('test@example.com', :advisor).member_title.should == 'Awesome Advisor'
        startup.user_meta('test@example.com', :advisor).role_identifier.should == 'advisor'
        response.should redirect_to(startup_path(startup))
      end

      it "shows update user partial" do
        get :update_user, :id              => startup.id,
                          :uid             => user.id,
                          :role_identifier => 'member'

        assigns(:user_meta).should == startup.user_meta(user)
      end

      it "updates a user" do
        post :update_user, :id              => startup.id,
                           :uid             => user.id,
                           :role_identifier => 'member',
                           :attributes      => { :member_title => 'CTO' }

        startup.user_meta(user).member_title.should == 'CTO'
        startup.user_meta(user).role_identifier.should == 'member'
        response.should redirect_to(startup_path(startup))
      end

      it "detaches a user" do
        startup.attach_user(user, :investor)

        post :detach_user, :id              => startup.id,
                           :uid             => user.id,
                           :role_identifier => 'investor'

        startup.reload

        startup.users.include?(user).should == true # true because user is still a member of the startup
        response.should redirect_to(startup_path(startup))
      end
    end
  end
end
