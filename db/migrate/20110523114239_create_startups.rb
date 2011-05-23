class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
      t.string :name
      t.string :pitch
      t.string :funds_to_raise
      t.text   :description
      t.text   :meta
      t.string :logo
      t.timestamps
    end
  end
end
