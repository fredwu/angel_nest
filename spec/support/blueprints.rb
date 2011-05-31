require 'machinist/active_record'

User.blueprint do
  name     { 'John Doe' }
  email    { "test#{sn}@example.com" }
  password { 'password' }
end

Investor.blueprint do
  name           { 'Arch Angel' }
  tagline        { 'Carry On Wayward Son' }
  funds_to_offer { 20_000 }
  description    { %q{Carry on my wayward son, there'll be peace when you are done.} }
end

Startup.blueprint do
  name           { 'Wuit' }
  pitch          { 'Building web applications that make sense.' }
  funds_to_raise { 10_000 }
  description    { %q{At Wuit we not only make web apps that make sense, we also share ideas and knowledge with the community.} }
end

Message.blueprint do
  content    { "Message content #{sn}." }
  is_private { false }
  user
end