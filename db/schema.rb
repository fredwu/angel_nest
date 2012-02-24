# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110717223142) do

  create_table "investor_profiles", :force => true do |t|
    t.string   "tagline"
    t.string   "funds_to_offer"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "investor_profiles", ["user_id"], :name => "index_investor_profiles_on_user_id"

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.boolean  "is_read",     :default => false
    t.boolean  "is_private",  :default => false
    t.boolean  "is_archived", :default => false
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "user_id"
    t.integer  "proposal_id"
    t.integer  "topic_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "messages", ["is_private", "target_type", "target_id"], :name => "comments_by_type"
  add_index "messages", ["is_read", "is_private", "target_type", "target_id"], :name => "comments_by_type_by_read"
  add_index "messages", ["topic_id"], :name => "index_messages_on_topic_id"
  add_index "messages", ["user_id", "is_private", "is_archived", "proposal_id"], :name => "comments_by_archived_by_proposal"
  add_index "messages", ["user_id", "is_private", "target_type", "target_id"], :name => "comments_by_type_by_user"
  add_index "messages", ["user_id", "proposal_id"], :name => "index_messages_on_user_id_and_proposal_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "proposal_for_investors", :id => false, :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "proposal_for_investors", ["proposal_id", "user_id"], :name => "index_proposal_for_investors_on_proposal_id_and_user_id"
  add_index "proposal_for_investors", ["proposal_id"], :name => "index_proposal_for_investors_on_proposal_id"
  add_index "proposal_for_investors", ["user_id"], :name => "index_proposal_for_investors_on_user_id"

  create_table "proposals", :force => true do |t|
    t.string   "proposal_stage_identifier"
    t.boolean  "new_business_model",                   :default => false
    t.boolean  "new_product",                          :default => false
    t.string   "pitch"
    t.text     "introduction"
    t.text     "one_year_target_audience"
    t.integer  "one_year_per_capita_annual_spending",  :default => 0
    t.integer  "one_year_number_of_users",             :default => 0
    t.integer  "one_year_market_cap",                  :default => 0
    t.integer  "one_year_penetration_rate",            :default => 0
    t.text     "one_year_marketing_strategy"
    t.integer  "one_year_gross_profit_margin",         :default => 0
    t.text     "five_year_target_audience"
    t.integer  "five_year_per_capita_annual_spending", :default => 0
    t.integer  "five_year_number_of_users",            :default => 0
    t.integer  "five_year_market_cap",                 :default => 0
    t.integer  "five_year_penetration_rate",           :default => 0
    t.text     "five_year_marketing_strategy"
    t.integer  "five_year_gross_profit_margin",        :default => 0
    t.text     "competitors_details"
    t.text     "competitive_edges"
    t.text     "competing_strategy"
    t.integer  "investment_amount",                    :default => 0
    t.string   "investment_currency"
    t.integer  "equity_percentage",                    :default => 0
    t.text     "spending_plan"
    t.integer  "next_investment_round",                :default => 0
    t.integer  "startup_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "proposals", ["proposal_stage_identifier"], :name => "index_proposals_on_proposal_stage_identifier"
  add_index "proposals", ["startup_id"], :name => "index_proposals_on_startup_id"

  create_table "startup_photos", :force => true do |t|
    t.string   "photo"
    t.integer  "startup_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "startup_photos", ["startup_id"], :name => "index_startup_photos_on_startup_id"

  create_table "startup_users", :force => true do |t|
    t.integer  "startup_id"
    t.string   "user_email"
    t.string   "role_identifier"
    t.string   "member_title",    :default => ""
    t.boolean  "confirmed",       :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "startup_users", ["confirmed"], :name => "index_startup_users_on_confirmed"
  add_index "startup_users", ["startup_id", "confirmed"], :name => "index_startup_users_on_startup_id_and_confirmed"
  add_index "startup_users", ["startup_id", "user_email"], :name => "index_startup_users_on_startup_id_and_user_email"
  add_index "startup_users", ["startup_id"], :name => "index_startup_users_on_startup_id"
  add_index "startup_users", ["user_email"], :name => "index_startup_users_on_user_email"

  create_table "startups", :force => true do |t|
    t.string   "name"
    t.string   "pitch"
    t.string   "funds_to_raise"
    t.string   "stage_identifier"
    t.string   "market_identifier"
    t.string   "location"
    t.text     "description"
    t.string   "logo"
    t.integer  "followers_count",   :default => 0
    t.integer  "followed_count",    :default => 0
    t.integer  "comments_count",    :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "startups", ["location"], :name => "index_startups_on_location"
  add_index "startups", ["market_identifier", "location"], :name => "index_startups_on_market_identifier_and_location"
  add_index "startups", ["name"], :name => "index_startups_on_name", :unique => true

  create_table "target_followers", :force => true do |t|
    t.integer  "follower_id"
    t.string   "follower_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "target_followers", ["follower_id", "target_type", "target_id"], :name => "target_followers_follwer", :unique => true
  add_index "target_followers", ["follower_id"], :name => "index_target_followers_on_follower_id"
  add_index "target_followers", ["follower_type", "follower_id", "target_type", "target_id"], :name => "target_followers_follwer_with_type", :unique => true
  add_index "target_followers", ["follower_type", "follower_id"], :name => "index_target_followers_on_follower_type_and_follower_id"
  add_index "target_followers", ["target_id"], :name => "index_target_followers_on_target_id"
  add_index "target_followers", ["target_type", "target_id"], :name => "index_target_followers_on_target_type_and_target_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email",                                 :default => "",    :null => false
    t.string   "location"
    t.string   "introduction"
    t.integer  "followers_count",                       :default => 0
    t.integer  "followed_count",                        :default => 0
    t.integer  "messages_count",                        :default => 0
    t.integer  "comments_count",                        :default => 0
    t.boolean  "is_admin",                              :default => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["location"], :name => "index_users_on_location"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
