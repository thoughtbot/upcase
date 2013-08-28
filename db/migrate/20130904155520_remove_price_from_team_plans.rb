class RemovePriceFromTeamPlans < ActiveRecord::Migration
  def change
    remove_column :team_plans, :price
  end
end
