class CreateInvestorProfiles < ActiveRecord::Migration
  def change
    create_table :investor_profiles do |t|
      t.string  :tagline
      t.string  :funds_to_offer
      t.text    :description
      t.integer :user_id
      t.timestamps
    end

    add_index :investor_profiles, :user_id
  end
end
