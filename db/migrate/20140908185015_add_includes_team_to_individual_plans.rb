class AddIncludesTeamToIndividualPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :individual_plans,
      :includes_team,
      :boolean,
      default: false,
      null: false
  end
end
