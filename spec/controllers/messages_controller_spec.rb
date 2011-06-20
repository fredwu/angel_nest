require 'spec_helper'

describe MessagesController do
  include_context "inherited_resources"

  let(:current_user) { User.make! }

  before do
    sign_in_user(current_user)
  end

  context "startup" do
    let(:startup) { Startup.make! }

    before do
      startup.attach_user(current_user)
    end

    it "accepts comments" do
      post :create, :startup_id => startup.id, :message => { :content => 'hello world' }

      startup = Startup.last

      startup.comments.first.content.should == 'hello world'
    end
  end
end
