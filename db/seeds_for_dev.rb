require File.dirname(__FILE__) + '/../spec/support/blueprints'

p 'Creating seeds data for development ...'

# primary user

user = User.make!({
  :username => 'fredwu',
  :name     => 'Fred Wu',
  :email    => 'ifredwu@gmail.com',
  :password => 'password',
})
user.confirm!

# more users

40.times do
  u = User.make!
  u.confirm!
end

# investors and startups

10.times { InvestorProfile.make! }
20.times { Startup.make! }

Startup.first.attach_user(user, :member, 'Founder')
Startup.first.confirm_user(user)

InvestorProfile.all.each do |investor_profile|
  User.new_users.first.investor_profile = investor_profile
end

user.investor_profile = InvestorProfile.make!

# startup founders and proposals

Startup.all.each do |startup|
  u = User.new_users.first
  startup.attach_user(u, :member, Faker::Lorem.word)
  startup.confirm_user(u)

  2.times { startup.submit_proposal(User.investors.sample, Proposal.make.attributes, 'draft') }
  startup.submit_proposal(User.investors.sample, Proposal.make.attributes, 'submitted', Faker::Lorem.sentence)
  startup.submit_proposal(user, Proposal.make.attributes, 'submitted', Faker::Lorem.sentence) if rand(5) == 0
  if rand(10) == 0
    startup.submit_proposal(user, Proposal.make.attributes, 'submitted', Faker::Lorem.sentence)
    Message.last.mark_as_archived!
  end
end

# follow/unfollow

User.limit(10).each do |u|
  user.follow(u)
end

User.limit(20).each do |u|
  u.follow(user)
end

# micro posts

(5 + rand(5)).times do
  User.order('RAND()').each do |u|
    u.add_micro_post(Faker::Lorem.sentence)
  end
end

# private messages

User.all.each do |u|
  20.times do
    target_user = User.order('RAND()').first
    u.send_private_message(target_user, Faker::Lorem.sentence)
    (2 + rand(2)).times do
      rand(2).times { target_user.reply_private_message(Message.topics.last, Faker::Lorem.sentence) }
      rand(2).times { u.reply_private_message(Message.topics.last, Faker::Lorem.sentence) }
    end
  end

  u.sent_messages.order('RAND()').limit(5).each { |msg| msg.mark_as_read! }
  u.sent_messages.order('RAND()').limit(5).each { |msg| msg.mark_as_archived! }
end

p 'Finished creating seeds data for development.'