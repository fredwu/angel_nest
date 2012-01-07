require 'spec_helper'

describe "session" do
  let(:user) do
    u = User.make!
    u.confirm!
    u
  end

  let(:startup) { Startup.make! }

  before do
    startup.attach_user(user, :member, 'Founder')

    post user_session_path, :user => {
                              :login    => user.email,
                              :password => 'password'
                            }

    get startups_path
  end

  it "records the last visited page for a normal GET request" do
    get investors_path

    session[:user_return_to].should == investors_path
  end

  it "doesn't record the last visited page for a normal POST request" do
    post my_private_messages_path, :users => 1, :message => { :content => 'hello' }, :format => :json

    session[:user_return_to].should == startups_path
  end

  it "doesn't record the last visited page for an AJAX GET request" do
    get startup_path(startup)
    xhr :get, startup_profile_details_path(startup)

    session[:user_return_to].should == startup_path(startup)
  end

  it "doesn't record the last visited page for an AJAX POST request" do
    get startup_path(startup)
    xhr :post, "#{startup_path(startup)}/update_user?role_identifier=member&uid=1", :member_title => 'CEO'

    session[:user_return_to].should == startup_path(startup)
  end
end
