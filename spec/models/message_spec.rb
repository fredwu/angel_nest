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

        subject.messages.count.should          == 4 # all messages (including comments)
        subject.messages_count.should          == 3 # all sent and received messages
        subject.micro_posts.count.should       == 2 # only micro posts
        subject.outgoing_messages.count.should == 1 # only outgoing messages
        subject.sent_messages.count.should     == 1 # only sent messages

        subject.micro_posts.first.content.should == 'hello ruby'
        subject.micro_posts.last.content.should == 'hello world'
      end

      it "has new messages?" do
        user.has_new_messages?.should == false

        subject.send_private_message(user, 'hey there!')

        user.has_new_messages?.should == true
        user.has_new_proposals?.should == false
      end

      context "private messages" do
        before do
          subject.send_private_message(user, 'hey there!')
        end

        it "sends private messages" do
          user.comments.count.should == 1
          user.incoming_messages.count.should == 1
          user.incoming_messages.public_only.count.should == 0
          user.inbox_messages.count.should == 1
          user.inbox_messages.unread.count.should == 1
          user.inbox_messages.read.count.should == 0

          private_message = user.inbox_messages.first

          private_message.is_private?.should == true
          private_message.is_public?.should == false
          private_message.is_with_proposal?.should == false
          private_message.is_without_proposal?.should == true
        end

        it "adds a reply to a topic" do
          topic = Message.first
          user.reply_private_message(topic, 'hey!!')

          topic.replies.count.should == 1
          topic.replies.first.content.should == 'hey!!'
          topic.replies.first.topic.content.should == 'hey there!'
        end

        it "marks as read" do
          message = user.incoming_messages.first

          message.is_read?.should == false
          message.is_unread?.should == true

          message.mark_as_read!

          message.is_read?.should == true
          message.is_unread?.should == false
        end

        it "marks as unread" do
          message = user.incoming_messages.first

          message.mark_as_read!
          message.mark_as_unread!

          message.is_read?.should == false
          message.is_unread?.should == true
        end

        it "marks as archived" do
          message = user.incoming_messages.first

          message.mark_as_archived!

          message.is_archived?.should == true
          message.is_unarchived?.should == false
        end

        it "marks as unarchived" do
          message = user.incoming_messages.first

          message.mark_as_archived!
          message.mark_as_unarchived!

          message.is_archived?.should == false
          message.is_unarchived?.should == true
        end
      end
    end
  end
end
