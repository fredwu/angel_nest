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

    context "micro posts" do
      it "has micro posts" do
        get :home

        assigns(:micro_posts).should == current_user.followed_micro_posts
      end

      it "adds micro posts via html" do
        post :add_micro_post, :message => { :content => 'Hello html!' }

        current_user.micro_posts.last.content.should == 'Hello html!'
        response.should redirect_to(request.env['HTTP_REFERER'])
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

        assigns(:micro_posts).should == current_user.micro_posts
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
