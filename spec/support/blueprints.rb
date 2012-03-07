require 'factory_girl'
require 'factory_girl/syntax/blueprint'
require 'factory_girl/syntax/make'

User.blueprint do
  u_name  = Faker::Name.name

  sequence(:username) { |n| "user_#{n}" }
  name                { u_name }
  email               { Faker::Internet.email(u_name) }
  location            { Faker::Address.city }
  introduction        { Faker::Lorem.sentence }
  password            { 'password' }
end

InvestorProfile.blueprint do
  tagline        { Faker::Company.catch_phrase }
  funds_to_offer { rand(2_000_000) }
  description    { Faker::Lorem.paragraphs * "\n\n" }
end

Startup.blueprint do
  name              { Faker::Company.name }
  pitch             { Faker::Company.catch_phrase }
  funds_to_raise    { rand(5_000_000) }
  description       { Faker::Lorem.paragraphs * "\n\n" }
  stage_identifier  { Startup.stages.keys.sample.to_s }
  market_identifier { Startup.markets.keys.sample.to_s }
  location          { Faker::Address.city }
end

Message.blueprint do
  content    { Faker::Lorem.paragraph(2) }
  is_private { [true, false, false, false, false].sample }
end

Proposal.blueprint do
  proposal_stage_identifier            { Proposal.stages.keys.sample }
  new_business_model                   { [true, false].sample }
  new_product                          { [true, false].sample }
  pitch                                { Faker::Company.catch_phrase }
  introduction                         { Faker::Lorem.paragraph }

  one_year_target_audience             { Faker::Lorem.sentence }
  one_year_per_capita_annual_spending  { rand(1_000) }
  one_year_number_of_users             { rand(1_000_000) }
  one_year_market_cap                  { rand(1_000_000_000) }
  one_year_penetration_rate            { rand(20.0) }
  one_year_marketing_strategy          { Faker::Lorem.paragraph }
  one_year_gross_profit_margin         { rand(20.0) }

  five_year_target_audience            { Faker::Lorem.sentence }
  five_year_per_capita_annual_spending { rand(1_000) }
  five_year_number_of_users            { rand(1_000_000) }
  five_year_market_cap                 { rand(1_000_000_000) }
  five_year_penetration_rate           { rand(20.0) }
  five_year_marketing_strategy         { Faker::Lorem.paragraph }
  five_year_gross_profit_margin        { rand(20.0) }

  competitors_details                  { Faker::Lorem.paragraph }
  competitive_edges                    { Faker::Lorem.paragraph }
  competing_strategy                   { Faker::Lorem.paragraph }

  investment_amount                    { rand(3_000_000) }
  investment_currency                  { Settings.currencies.sample }
  equity_percentage                    { rand(30) }
  spending_plan                        { Faker::Lorem.paragraph }
  next_investment_round                { rand(24) }

  startup                              { Startup.make }
end
