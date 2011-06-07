require 'machinist/active_record'

User.blueprint do
  u_name  = Faker::Name.name

  name     { u_name }
  email    { Faker::Internet.email(u_name) }
  password { Faker::Internet.user_name(u_name) }
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
  stage_identifier  { I18n.t('group.stage_identifiers').keys.sample }
  market_identifier { I18n.t('group.market_identifiers').keys.sample }
end

Message.blueprint do
  content    { Faker::Lorem.paragraph(2) }
  is_private { [true, false, false, false, false].sample }
  user
end
