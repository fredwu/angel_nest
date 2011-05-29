class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text    :content
      t.boolean :is_private, :default => false
      t.integer :target_id
      t.string  :target_type
      t.integer :user_id
      t.timestamps
    end

    add_index :messages, :user_id
    add_index :messages, [:is_private, :target_type, :target_id], :name => :comments_by_type
    add_index :messages, [:user_id, :is_private, :target_type, :target_id], :name => :comments_by_type_by_user
  end
end
