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

10.times { Investor.make! }
20.times { Startup.make! }

Startup.first.attach_user(user)

Investor.all.each do |investor|
  User.new_users.first.investor = investor
end

Startup.all.each do |startup|
  startup.attach_user(User.new_users.first, :founder)
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