class CreateStartupUsers < ActiveRecord::Migration
  def change
    create_table :startup_users do |t|
      t.integer :startup_id
      t.string  :user_email
      t.string  :role_identifier
      t.string  :member_title, :default => ''
      t.boolean :confirmed

      t.timestamps
    end

    add_index :startup_users, :startup_id
    add_index :startup_users, :user_email
    add_index :startup_users, [:startup_id, :user_email]
    add_index :startup_users, :confirmed
    add_index :startup_users, [:startup_id, :confirmed]
  end
end
