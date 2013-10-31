class MoveTeamPlanDataToDatabase < ActiveRecord::Migration
  def change
    add_column :team_plans, :individual_price, :integer, null: true
    add_column :team_plans, :terms, :text
    add_column :team_plans, :includes_mentor, :boolean, null: false, default: true
    add_column :team_plans, :includes_workshops, :boolean, null: false, default: true
    add_column :team_plans, :featured, :boolean, null: false, default: true
    add_column :team_plans, :description, :text

    update 'update team_plans set individual_price=1299'
    change_column_null :team_plans, :individual_price, true

    update "update team_plans set terms='No minimum subscription length. Cancel at any time.'"
  end
end
