require 'spec_helper'

describe "user session" do
  let(:user) do
    u = User.make!
    u.confirm!
    u
  end

  def sign_in_user(user = user)
    post user_session_path, :user => {
                              :email    => user.email,
                              :password => 'password'
                            }
  end

  it "sees sign in page" do
    get new_user_session_path

    response.status.should == 200
    response.body.should include('Sign in')
  end

  it "signs in" do
    sign_in_user

    response.should redirect_to(root_path)
    follow_redirect!
    response.body.should include(user.name)
  end

  it "signs out" do
    sign_in_user
    get destroy_user_session_path

    response.should redirect_to(root_path)
    follow_redirect!
    response.body.should_not include(user.name)
  end
end
