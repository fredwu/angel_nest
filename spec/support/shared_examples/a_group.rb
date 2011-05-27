shared_examples "a group" do
  it_behaves_like "commentables"
  it_behaves_like "followables"

  subject { described_class.new }

  describe "associations" do
    it "has users" do
      subject.association(:users).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
    end

    it "has user groups" do
      subject.association(:user_groups).should be_a(ActiveRecord::Associations::HasManyAssociation)
    end
  end

  describe "user roles in groups" do
    subject       { described_class.make! }
    let(:founder) { User.make! }
    let(:user)    { User.make! }

    before(:each) do
      subject.attach_user(founder, :founder)
    end

    it "has a founding user and role" do
      subject.users.count.should == 1
      subject.users.first == founder
      subject.user_groups.first.role_identifier == 'founder'
    end

    it "attaches a user" do
      subject.attach_user(user, :advisor)
      subject.users.count.should == 2
      subject.users.last == user
    end

    it "detaches a user" do
      subject.attach_user(user)
      subject.detach_user(user)
      subject.users.count.should == 1
      subject.users.last == founder
      User.last.should == user
    end
  end
end