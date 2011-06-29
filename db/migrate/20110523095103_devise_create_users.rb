class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :username
      t.string  :name
      t.string  :email
      t.string  :location
      t.integer :followers_count, :default => 0
      t.integer :followed_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :messages_count, :default => 0
      t.boolean :is_admin, :default => false

      t.database_authenticatable :null => false
      t.token_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      t.timestamps
    end

    add_index :users, :username,             :unique   => true
    add_index :users, :name
    add_index :users, :email,                :unique   => true
    add_index :users, :location
    add_index :users, :is_admin
    add_index :users, :reset_password_token, :unique   => true
    add_index :users, :confirmation_token,   :unique   => true
    add_index :users, :authentication_token, :unique   => true
  end
end
