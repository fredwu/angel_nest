shared_examples "a venture" do
  subject { described_class.new }

  describe "associations" do
    it "has users" do
      subject.association(:users).should be_a(ActiveRecord::Associations::HasManyThroughAssociation)
    end

    it "has user ventures" do
      subject.association(:user_ventures).should be_a(ActiveRecord::Associations::HasManyAssociation)
    end
  end
end