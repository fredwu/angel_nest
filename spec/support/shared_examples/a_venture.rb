shared_examples "a venture" do
  it_behaves_like "commentables"
  it_behaves_like "followables"

  subject { described_class.new }

  describe "associations" do
    it "has users" do
      subject.association(:users).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
    end

    it "has user ventures" do
      subject.association(:user_ventures).should be_a(ActiveRecord::Associations::HasManyAssociation)
    end
  end

  describe "user roles in ventures" do
    subject       { described_class.make! }
    let(:founder) { User.make! }
    let(:user)    { User.make! }

    before(:each) do
      subject.add_user(founder, :founder)
    end

    it "has a founding user and role" do
      subject.users.count.should == 1
      subject.users.first == founder
      subject.user_ventures.first.venture_role == 'founder'
    end

    it "adds a user" do
      subject.add_user(user, :advisor)
      subject.users.count.should == 2
      subject.users.last == user
    end

    it "removes a user" do
      subject.add_user(user)
      subject.remove_user(user)
      subject.users.count.should == 1
      subject.users.last == founder
    end
  end
end