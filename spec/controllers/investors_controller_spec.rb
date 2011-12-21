require 'spec_helper'

describe InvestorsController do
  it_behaves_like "ensure_ownership"
  include_context "inherited_resources"

  let(:current_user) { User.make! }

  before do
    sign_in_user(current_user)
  end

  it "shows the index" do
    get :index

    collection.should == User.investors.page(1)
    response.should be_success
  end

  it "shows pagination" do
    get :index, :page => 99

    collection.should == User.investors.page(99)
    response.should be_success
  end
end
