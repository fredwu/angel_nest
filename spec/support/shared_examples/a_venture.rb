shared_examples "a venture" do
  subject { described_class.new }

  describe "belongings" do
    it "belongs to a user" do
      subject.association(:users).should be_a(ActiveRecord::Associations::HasManyAssociation)
    end
  end
end