class CreateUserFollowers < ActiveRecord::Migration
  def change
    create_table :user_followers, :id => false do |t|
      t.integer :user_id
      t.integer :follower_id
      t.timestamps
    end

    add_index :user_followers, :user_id
    add_index :user_followers, :follower_id
    add_index :user_followers, [:user_id, :follower_id], :unique => true
  end
end
