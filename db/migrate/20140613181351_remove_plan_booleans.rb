class RemovePlanBooleans < ActiveRecord::Migration
  def up
    remove_column :individual_plans, :includes_workshops
    remove_column :team_plans, :includes_workshops

    remove_column :individual_plans, :includes_mentor
    remove_column :team_plans, :includes_mentor
  end

  def down
    with_options(default: true) do |table|
      table.add_column :individual_plans, :includes_workshops, :boolean
      table.add_column :team_plans, :includes_workshops, :boolean, null: false
    end

    with_options(default: false) do |table|
      table.add_column :individual_plans, :includes_mentor, :boolean
      table.add_column :team_plans, :includes_mentor, :boolean, null: false
    end
  end
end
