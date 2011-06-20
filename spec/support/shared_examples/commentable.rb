shared_examples "commentable" do
  subject    { described_class.make! }
  let(:user) { User.make! }

  it "does not allow alteration on counter cache fields" do
    subject.comments_count = 10
    subject.save!
    subject.reload

    subject.comments.count.should == 0
    subject.comments_count.should == 0
  end

  it "allows commenting" do
    subject.add_comment(user, 'This is great!')

    subject.comments.count.should == 1
    subject.comments_count.should == 1
  end

  it "allows private commenting" do
    subject.add_private_comment(user, 'This is great!')

    subject.comments.count.should == 1
    subject.comments_count.should == 1
    subject.comments.public.count.should == 0
    subject.comments.private.count.should == 1
  end
end