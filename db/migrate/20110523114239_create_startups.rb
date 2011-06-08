class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
      t.string  :name
      t.string  :pitch
      t.string  :funds_to_raise
      t.string  :stage_identifier
      t.string  :market_identifier
      t.text    :description
      t.string  :logo
      t.integer :followers_count, :default => 0
      t.integer :followed_count, :default => 0
      t.integer :comments_count, :default => 0
      t.timestamps
    end

    add_index :startups, :name, :unique => true
  end
end
