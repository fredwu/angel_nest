require 'spec_helper'

describe Message do
  context "user" do
    subject    { User.make! }
    let(:user) { User.make! }

    it "has no posted messages by default" do
      subject.messages.count.should == 0
    end

    describe "micro posts" do
      it "returns true when successful" do
        subject.add_micro_post('hello').should == true
      end

      it "returns false when not successful" do
        subject.add_micro_post(' ').should == false
      end

      it "ignores empty micro posts" do
        subject.add_micro_post(' ')
        subject.micro_posts.count.should == 0
      end

      it "errors out if it's longer than 140 characters" do
        subject.add_micro_post('a' * 141)
        subject.micro_posts.count.should == 0
      end

      it "has no micro posts by default" do
        subject.micro_posts.count.should == 0
      end

      it "posts micro posts" do
        time_travel_to(1.minute.ago) { subject.add_micro_post('hello world') }
        subject.add_micro_post('hello ruby')

        subject.send_private_message(user, 'hey there!')

        startup = Startup.make!
        startup.add_comment(subject, 'this is a comment for a startup')

        subject.sent_messages.count.should == 4 # all messages (including comments)
        subject.messages_count.should == 3 # all sent and received messages of a user
        subject.micro_posts.count.should   == 2 # only micro posts

        subject.micro_posts.first.content.should == 'hello ruby'
        subject.micro_posts.last.content.should == 'hello world'
      end

      it "sends private messages" do
        subject.send_private_message(user, 'hey there!')

        user.comments.count.should == 1
        user.received_messages.count.should == 1
        user.received_messages.public.count.should == 0
        user.received_messages.private.count.should == 1
        user.received_messages.private.unread.count.should == 1
        user.received_messages.private.read.count.should == 0
      end
    end
  end
end
