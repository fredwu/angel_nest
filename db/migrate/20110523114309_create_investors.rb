class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.string  :name
      t.string  :tagline
      t.string  :funds_to_offer
      t.text    :description
      t.string  :logo
      t.integer :followers_count, :default => 0
      t.integer :followed_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :user_id
      t.timestamps
    end
  end
end
