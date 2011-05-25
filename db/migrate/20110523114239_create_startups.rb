class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
      t.string  :name
      t.string  :pitch
      t.string  :funds_to_raise
      t.text    :description
      t.string  :logo
      t.integer :followers_count, :default => 0
      t.integer :followed_count, :default => 0
      t.integer :comments_count, :default => 0
      t.timestamps
    end
  end
end
