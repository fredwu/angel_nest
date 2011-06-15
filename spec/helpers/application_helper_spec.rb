require 'spec_helper'

describe ApplicationHelper do
  it "has #time_ago" do
    helper.time_ago(Time.now).should include(time_ago_in_words(Time.now))
  end

  it "has #time_ago_by" do
    helper.time_ago_by(Time.now).should include(time_ago_in_words(Time.now))
  end

  it "has #link_to_current" do
    path = '/'
    helper.link_to_current('test', path).should == helper.link_to('test', path)

    @request.env['PATH_INFO'] = path
    helper.link_to_current('test', path).should == helper.link_to('test', path, :class => :current)
  end

  it "displays a follow/unfollow button" do
    current_user = User.make!
    target       = Startup.make!
    helper.stub(:current_user).and_return(current_user)

    helper.follow_button(target).should include(I18n.t('label.follow'))

    current_user.follow(target)

    helper.follow_button(target).should include(I18n.t('label.unfollow'))
  end
end
