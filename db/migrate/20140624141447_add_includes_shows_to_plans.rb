class AddIncludesShowsToPlans < ActiveRecord::Migration
  def change
    add_column(
      :individual_plans,
      :includes_shows,
      :boolean,
      default: true,
      null: false
    )
    add_column(
      :team_plans,
      :includes_shows,
      :boolean,
      default: true,
      null: false
    )
  end
end
