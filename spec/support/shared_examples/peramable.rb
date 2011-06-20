shared_examples "paramable" do
  subject    { described_class.make! }
  let(:user) { User.make! }

  it "has a permalink" do
    subject.respond_to?(:to_param).should == true
  end

  it "reads the permalink" do
    subject.to_param.should == "#{subject.id}-#{subject.name.parameterize}"
  end
end