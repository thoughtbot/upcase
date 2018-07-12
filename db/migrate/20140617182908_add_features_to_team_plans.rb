class AddFeaturesToTeamPlans < ActiveRecord::Migration[4.2]
  def change
    with_options default: true, null: false do |table|
      table.add_column :team_plans, :includes_exercises, :boolean
      table.add_column :team_plans, :includes_source_code, :boolean
      table.add_column :team_plans, :includes_forum, :boolean
      table.add_column :team_plans, :includes_books, :boolean
      table.add_column :team_plans, :includes_screencasts, :boolean
      table.add_column :team_plans, :includes_office_hours, :boolean
    end
  end
end
