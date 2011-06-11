class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.string  :proposal_stage_identifier
      t.text    :details
      t.integer :startup_id
      t.timestamps
    end

    add_index :proposals, :startup_id

    create_table :proposal_for_investors, :id => false do |t|
      t.integer :proposal_id
      t.integer :investor_id
      t.timestamps
    end

    add_index :proposal_for_investors, :proposal_id
    add_index :proposal_for_investors, :investor_id
    add_index :proposal_for_investors, [:proposal_id, :investor_id]
  end
end
