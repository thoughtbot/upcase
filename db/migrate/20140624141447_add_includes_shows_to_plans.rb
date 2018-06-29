class AddIncludesShowsToPlans < ActiveRecord::Migration[4.2]
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
