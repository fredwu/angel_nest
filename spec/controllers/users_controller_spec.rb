require 'spec_helper'

describe UsersController do
  it "redirects to the login page" do
    get :followed_micro_posts
    response.should redirect_to(new_user_session_url)
  end

  context "logged in" do
    let(:current_user) { User.make! }
    let(:user)         { User.make! }

    before do
      controller.stub(:current_user).and_return(current_user)
      sign_in current_user
    end

    context "micro posts" do
      before do
        request.env['HTTP_REFERER'] = users_followed_micro_posts_url
        current_user.follow(user)
        user.add_micro_post('Hello world!')
      end

      it "has micro posts" do
        get :followed_micro_posts

        assigns(:micro_posts).should == current_user.followed_micro_posts
      end

      it "adds micro posts via html" do
        post :add_micro_post, :content => 'Hello html!'

        current_user.micro_posts.last.content.should == 'Hello html!'
        response.should redirect_to(request.env['HTTP_REFERER'])
      end

      it "adds micro posts via json" do
        post :add_micro_post, :content => 'Hello json!', :format => :json

        current_user.micro_posts.last.content.should == 'Hello json!'
        response.should be_success
        response.body.should == true.to_json
      end
    end
  end
end
