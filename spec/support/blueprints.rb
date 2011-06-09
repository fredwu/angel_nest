require 'machinist/active_record'

User.blueprint do
  u_name  = Faker::Name.name

  username { "user_#{sn}" }
  name     { u_name }
  email    { Faker::Internet.email(u_name) }
  password { 'password' }
end

Investor.blueprint do
  name           { Faker::Company.name }
  tagline        { Faker::Company.catch_phrase }
  funds_to_offer { rand(2_000_000) }
  description    { Faker::Lorem.paragraphs * "\n\n" }
end

Startup.blueprint do
  name              { Faker::Company.name }
  pitch             { Faker::Company.catch_phrase }
  funds_to_raise    { rand(5_000_000) }
  description       { Faker::Lorem.paragraphs * "\n\n" }
  stage_identifier  { Startup.stages.keys.sample }
  market_identifier { Startup.markets.keys.sample }
end

Message.blueprint do
  content    { Faker::Lorem.paragraph(2) }
  is_private { [true, false, false, false, false].sample }
  user
end
