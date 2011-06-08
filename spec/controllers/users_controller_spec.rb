require 'spec_helper'

describe UsersController do
  test_authentication :home,
                      :add_micro_post,
                      :show

  context "logged in" do
    let(:current_user) { User.make! }
    let(:user)         { User.make! }

    before do
      controller.stub(:current_user).and_return(current_user)
      sign_in current_user

      request.env['HTTP_REFERER'] = my_home_url

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
      it "has micro posts" do
        get :show

        assigns(:micro_posts).should == current_user.micro_posts
      end
    end
  end
end
