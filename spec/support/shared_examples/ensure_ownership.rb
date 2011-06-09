shared_examples "ensure_ownership" do
  let(:current_user) { User.make! }
  let(:user)         { User.make! }

  before do
    controller.stub(:current_user).and_return(current_user)
  end

  it "denies #new" do
    get :new, :user_id => user.id

    response.status.should == 403
  end

  it "denies #create" do
    post :create, :user_id => user.id

    response.status.should == 403
  end

  it "denies #edit" do
    get :edit, :user_id => user.id, :id => 1

    response.status.should == 403
  end

  it "denies #update" do
    post :update, :user_id => user.id, :id => 1

    response.status.should == 403
  end

  it "denies #destroy" do
    post :destroy, :user_id => user.id, :id => 1

    response.status.should == 403
  end
end