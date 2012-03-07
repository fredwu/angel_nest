require File.dirname(__FILE__) + '/../spec/support/blueprints'

p 'Cleaning up temp data ...'

FileUtils.rm_rf(File.join(Rails.root, 'public', 'uploads'))

p 'Finished cleaning up temp data.'

p 'Creating seeds data for development ...'

# primary user
p ' > users ...'

user = User.make!({
  :username => 'fredwu',
  :name     => 'Fred Wu',
  :email    => 'test@example.com',
  :password => 'password',
})

# more users

40.times { User.make! }
User.all.each { |u| u.confirm! }

# investors and startups
p ' > investors and startups ...'

10.times { InvestorProfile.make! }
20.times { Startup.make! }

Startup.first.attach_user(user, :member, 'Founder')
Startup.first.confirm_user(user)

InvestorProfile.all.each do |investor_profile|
  User.new_users.first.investor_profile = investor_profile
end

user.investor_profile = InvestorProfile.make!

# startup founders and proposals
p ' > startup founders and proposals ...'

Startup.all.each do |startup|
  u = User.new_users.first
  startup.attach_user(u, :member, Faker::Lorem.word)
  startup.confirm_user(u)

  if rand(2) == 0
    startup.create_proposal(User.investors.sample, Proposal.make.attributes, 'draft')
  else
    startup.create_proposal(user, Proposal.make.attributes, 'submitted')
  end
end

# follow/unfollow
p ' > follow/unfollow ...'

User.limit(10).each do |u|
  user.follow(u)
end

User.limit(20).each do |u|
  u.follow(user)
end

# micro posts
p ' > micro posts ...'

(3 + rand(3)).times do
  User.order('RAND()').each do |u|
    u.add_micro_post(Faker::Lorem.sentence)
  end
end

# private messages
p ' > private messages ...'

User.all.each do |u|
  3.times do
    target_user = User.order('RAND()').first
    u.send_private_message(user, Faker::Lorem.sentence) if rand(5) == 0
    u.send_private_message(target_user, Faker::Lorem.sentence)
    (1 + rand(1)).times do
      rand(2).times { target_user.reply_private_message(Message.topics.last, Faker::Lorem.sentence) }
      rand(2).times { u.reply_private_message(Message.topics.last, Faker::Lorem.sentence) }
    end
  end

  u.sent_messages.order('RAND()').limit(3).each { |msg| msg.mark_as_read! }
  u.sent_messages.order('RAND()').limit(3).each { |msg| msg.mark_as_archived! }
end

p 'Finished creating seeds data for development.'