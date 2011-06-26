class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.string  :proposal_stage_identifier

      t.boolean :new_business_model,                   :default => false
      t.boolean :new_product,                          :default => false
      t.string  :pitch
      t.text    :introduction

      t.text    :one_year_target_audience
      t.integer :one_year_per_capita_annual_spending,  :default => 0
      t.integer :one_year_number_of_users,             :default => 0
      t.integer :one_year_market_cap,                  :default => 0
      t.integer :one_year_penetration_rate,            :default => 0
      t.text    :one_year_marketing_strategy
      t.integer :one_year_gross_profit_margin,         :default => 0

      t.text    :five_year_target_audience
      t.integer :five_year_per_capita_annual_spending, :default => 0
      t.integer :five_year_number_of_users,            :default => 0
      t.integer :five_year_market_cap,                 :default => 0
      t.integer :five_year_penetration_rate,           :default => 0
      t.text    :five_year_marketing_strategy
      t.integer :five_year_gross_profit_margin,        :default => 0

      t.text    :competitors_details
      t.text    :competitive_edges
      t.text    :competing_strategy

      t.integer :investment_amount,                    :default => 0
      t.string  :investment_currency
      t.integer :equity_percentage,                    :default => 0
      t.text    :spending_plan
      t.integer :next_investment_round,                :default => 0

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
