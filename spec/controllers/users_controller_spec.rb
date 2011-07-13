require 'spec_helper'

describe UsersController do
  include_context "inherited_resources"

  authenticates_gets :home,
                     :add_micro_post,
                     :show

  authenticates_posts

  context "logged in" do
    let(:current_user) { User.make! }
    let(:user)         { User.make! }
    let(:startup)      { Startup.make! }

    before do
      sign_in_user(current_user)

      current_user.follow(user)
      user.add_micro_post('Hello world!')
    end

    it "shows the index" do
      get :index

      collection.should == User.page(1)
      response.should be_success
    end

    context "messages" do
      it "shows inbox messages by default" do
        get :message_inboxes

        assigns(:messages).should == current_user.inbox_messages
      end

      it "shows inbox messages" do
        get :message_inboxes, :type => :inbox

        assigns(:messages).should == current_user.inbox_messages
      end

      it "shows sent messages" do
        get :message_inboxes, :type => :sent_messages

        assigns(:messages).should == current_user.sent_messages
      end

      it "shows archived messages" do
        get :message_inboxes, :type => :archived_messages

        assigns(:messages).should == current_user.archived_messages
      end

      it "shows new proposals" do
        get :message_inboxes, :type => :inbox_proposals

        assigns(:messages).should == current_user.inbox_proposals
      end

      it "shows sent proposals" do
        get :message_inboxes, :type => :sent_proposals

        assigns(:messages).should == current_user.sent_proposals
      end

      it "shows archived proposals" do
        get :message_inboxes, :type => :archived_proposals

        assigns(:messages).should == current_user.archived_proposals
      end
    end

    context "micro posts" do
      it "has micro posts" do
        get :home

        assigns(:micro_posts).should == current_user.followed_micro_posts.page(1)
      end

      it "adds micro posts via html" do
        post :add_micro_post, :message => { :content => 'Hello html!' }

        current_user.micro_posts.last.content.should == 'Hello html!'
        response.should redirect_back
      end

      it "adds micro posts via json" do
        post :add_micro_post, :message => { :content => 'Hello json!' }, :format => :json

        current_user.micro_posts.last.content.should == 'Hello json!'
        response.should be_success
        response.body.should == true.to_json
      end
    end

    context "user profile" do
      let(:user) { User.make!(:username => 'angel') }

      it "accepts :id as the parameter" do
        get :show, :id => user.id

        resource.should == user
      end

      it "accepts :username as the parameter" do
        get :show, :username => 'angel'

        resource.should == user
      end

      it "routes to /u/:username" do
        { :get => '/u/angel' }.should be_routable
      end

      it "has micro posts" do
        get :show

        assigns(:micro_posts).should == current_user.micro_posts.page(1)
      end
    end

    context "follow/unfollow targets" do
      it "follows a target" do
        post :follow_target, :target_id => startup.id, :target_type => 'Startup'

        response.should be_redirect
        current_user.is_following?(startup).should == true
      end

      it "unfollows a target" do
        post :unfollow_target, :target_id => startup.id, :target_type => 'Startup'

        response.should be_redirect
        current_user.is_following?(startup).should == false
      end
    end
  end
end
