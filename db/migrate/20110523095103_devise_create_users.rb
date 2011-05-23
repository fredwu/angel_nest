class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :password
      t.boolean :is_admin

      t.database_authenticatable :null => false
      t.token_authenticatable
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both

      t.timestamps
    end

    add_index :users, :name,                 :fulltext => true
    add_index :users, :email,                :unique   => true
    add_index :users, :is_admin
    add_index :users, :reset_password_token, :unique   => true
    add_index :users, :confirmation_token,   :unique   => true
    add_index :users, :unlock_token,         :unique   => true
    add_index :users, :authentication_token, :unique   => true
  end
end
