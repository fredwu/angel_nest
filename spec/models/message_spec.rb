require 'spec_helper'

describe Message do
  context "user" do
    subject    { User.make! }
    let(:user) { User.make! }

    it "has no posted messages by default" do
      subject.messages.count.should == 0
    end

    describe "micro posts" do
      it "has no micro posts by default" do
        subject.micro_posts.count.should == 0
      end

      it "posts micro posts" do
        time_travel_to(1.minute.ago) { subject.add_micro_post('hello world') }
        subject.add_micro_post('hello ruby')

        subject.send_private_message(user, 'hey there!')

        startup = Startup.make!
        startup.add_comment(subject, 'this is a comment for a startup')

        subject.messages.count.should    == 4 # all messages (including comments)
        subject.messages_count.should    == 3 # all sent and received messages of a user
        subject.micro_posts.count.should == 2 # only micro posts
        subject.micro_posts.first.content.should == 'hello ruby'
        subject.micro_posts.last.content.should == 'hello world'
      end
    end
  end
end
