require 'spec_helper'

describe EntrepreneursController do
  include_context "inherited_resources"

  let(:current_user) { User.make! }

  before do
    sign_in_user(current_user)
  end

  it "shows the index" do
    get :index

    collection.should == User.entrepreneurs.page(1)
    response.should be_success
  end

  it "shows pagination" do
    get :index, :page => 99

    collection.should == User.entrepreneurs.page(99)
    response.should be_success
  end
end
