class CreateAngels < ActiveRecord::Migration
  def change
    create_table :angels do |t|
      t.string  :name
      t.string  :tagline
      t.string  :funds_to_offer
      t.text    :description
      t.text    :meta
      t.string  :logo
      t.integer :followers_count, :default => 0
      t.integer :followings_count, :default => 0
      t.timestamps
    end
  end
end
