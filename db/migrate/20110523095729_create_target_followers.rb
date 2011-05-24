class CreateTargetFollowers < ActiveRecord::Migration
  def change
    create_table :target_followers, :id => false do |t|
      t.integer :follower_id
      t.string  :follower_type
      t.integer :target_id
      t.string  :target_type
      t.timestamps
    end

    add_index :target_followers, :follower_id
    add_index :target_followers, [:target_type, :target_id]
    add_index :target_followers, [:follower_id, :target_type, :target_id], :unique => true, :name => :target_followers_follwer
    add_index :target_followers, :target_id
    add_index :target_followers, [:follower_type, :follower_id]
    add_index :target_followers, [:target_id, :follower_type, :follower_id], :unique => true, :name => :target_followers_target
  end
end
