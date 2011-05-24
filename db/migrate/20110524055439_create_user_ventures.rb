class CreateUserVentures < ActiveRecord::Migration
  def change
    create_table :user_ventures do |t|
      t.integer :user_id
      t.integer :venture_id
      t.string  :venture_type
      t.string  :venture_role

      t.timestamps
    end

    add_index :user_ventures, :user_id
    add_index :user_ventures, [:venture_type, :venture_id]
    add_index :user_ventures, [:user_id, :venture_type, :venture_id]
  end
end
