require File.dirname(__FILE__) + '/../spec/support/blueprints'

p 'Creating seeds data for development ...'

user = User.make!({
  :username => 'fredwu',
  :name     => 'Fred Wu',
  :email    => 'ifredwu@gmail.com',
  :password => 'password',
})
user.confirm!

40.times do
  u = User.make!
  u.confirm!
end

10.times { InvestorProfile.make! }
20.times { Startup.make! }

Startup.first.attach_user(user, :member, 'Founder')
Startup.first.confirm_user(user)

InvestorProfile.all.each do |investor|
  User.new_users.first.investor_profile = investor
end

Startup.all.each do |startup|
  u = User.new_users.first
  startup.attach_user(u, :member, Faker::Lorem.word)
  startup.confirm_user(u)
  2.times do
    startup.submit_proposal(User.investors.sample, Proposal.make.attributes, 'draft')
  end
end

User.limit(10).each do |u|
  user.follow(u)
end

User.limit(20).each do |u|
  u.follow(user)
end

User.order('RAND()').each do |u|
  u.add_micro_post(Faker::Lorem.sentences * ' ')
end

p 'Finished creating seeds data for development.'