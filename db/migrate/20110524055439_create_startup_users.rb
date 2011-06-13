class CreateStartupUsers < ActiveRecord::Migration
  def change
    create_table :startup_users do |t|
      t.integer :startup_id
      t.integer :user_id
      t.string  :role_identifier
      t.string  :member_title, :default => ''

      t.timestamps
    end

    add_index :startup_users, :startup_id
    add_index :startup_users, :user_id
    add_index :startup_users, [:startup_id, :user_id]
  end
end
