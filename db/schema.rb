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

ActiveRecord::Schema.define(:version => 20110523114309) do

  create_table "angels", :force => true do |t|
    t.string   "name"
    t.string   "tagline"
    t.string   "funds_to_offer"
    t.text     "description"
    t.text     "meta"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "startups", :force => true do |t|
    t.string   "name"
    t.string   "pitch"
    t.string   "funds_to_raise"
    t.text     "description"
    t.text     "meta"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_followers", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_followers", ["follower_id"], :name => "index_user_followers_on_follower_id"
  add_index "user_followers", ["user_id", "follower_id"], :name => "index_user_followers_on_user_id_and_follower_id", :unique => true
  add_index "user_followers", ["user_id"], :name => "index_user_followers_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "password"
    t.string   "venture_title"
    t.boolean  "is_admin"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
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
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
