class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.string  :proposal_stage_identifier

      t.boolean :new_business_model,         :default => false
      t.boolean :new_product,                :default => false
      t.string  :pitch
      t.text    :introduction

      t.text    :target_audience
      t.integer :per_capita_annual_spending, :default => 0
      t.integer :number_of_users,            :default => 0
      t.integer :market_cap,                 :default => 0
      t.integer :penetration_rate,           :default => 0
      t.text    :marketing_strategy
      t.integer :gross_profit_margin,        :default => 0

      t.text    :competitors_details
      t.text    :competitive_edges
      t.text    :competing_strategy

      t.integer :investment_amount,          :default => 0
      t.string  :investment_currency
      t.integer :equity_percentage,          :default => 0
      t.text    :spending_plan
      t.integer :next_investment_round,      :default => 0

      t.integer :startup_id
      t.timestamps
    end

    add_index :proposals, :proposal_stage_identifier
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
