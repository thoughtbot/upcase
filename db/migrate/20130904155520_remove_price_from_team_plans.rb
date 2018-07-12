class RemovePriceFromTeamPlans < ActiveRecord::Migration[4.2]
  def change
    remove_column :team_plans, :price
  end
end
