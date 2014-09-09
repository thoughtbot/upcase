class AddIncludesTeamToIndividualPlans < ActiveRecord::Migration
  def change
    add_column :individual_plans,
               :includes_team,
               :boolean,
               default: false,
               null: false
  end
end
