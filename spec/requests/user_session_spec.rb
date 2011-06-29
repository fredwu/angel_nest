require 'spec_helper'

describe "user session" do
  let(:user) do
    u = User.make!
    u.confirm!
    u
  end

  let(:user_unconfirmed) { User.make! }

  def sign_in_user(login = user.email)
    post user_session_path, :user => {
                              :login    => login,
                              :password => 'password'
                            }
  end

  it "sees sign in page" do
    get new_user_session_path

    response.status.should == 200
    response.body.should include('Sign in')
  end

  it "signs in using email" do
    sign_in_user

    response.should redirect_to(root_path)
    follow_redirect!
    response.body.should include(user.name)
  end

  it "signs in using username" do
    sign_in_user(user.username)

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

  it "sends user confirmation instructions" do
    post user_confirmation_path, :user => {
                                   :email => user_unconfirmed.email
                                 }

    response.should redirect_to(new_user_session_path)
  end

  it "sends reset password instructions" do
    post user_password_path, :user => {
                               :login => user.email
                             }

    response.should redirect_to(new_user_session_path)
  end
end
