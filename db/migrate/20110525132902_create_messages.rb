class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text    :content
      t.boolean :is_read,     :default => false
      t.boolean :is_private,  :default => false
      t.boolean :is_archived, :default => false
      t.integer :target_id
      t.string  :target_type
      t.integer :user_id
      t.integer :proposal_id
      t.integer :topic_id
      t.timestamps
    end

    add_index :messages, :user_id
    add_index :messages, :topic_id
    add_index :messages, [:user_id, :proposal_id]
    add_index :messages, [:is_private, :target_type, :target_id], :name => :comments_by_type
    add_index :messages, [:is_read, :is_private, :target_type, :target_id], :name => :comments_by_type_by_read
    add_index :messages, [:user_id, :is_private, :target_type, :target_id], :name => :comments_by_type_by_user
    add_index :messages, [:user_id, :is_private, :is_archived, :proposal_id], :name => :comments_by_archived_by_proposal
  end
end
