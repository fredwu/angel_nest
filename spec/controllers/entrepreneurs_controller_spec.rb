require 'spec_helper'

describe EntrepreneursController do
  it_behaves_like "ensure_ownership"
  include_context "inherited_resources"

  let(:current_user) { User.make! }

  before do
    sign_in_user(current_user)
  end

  it "shows the index" do
    get :index

    collection.should == User.entrepreneurs
    response.should be_success
  end
end
