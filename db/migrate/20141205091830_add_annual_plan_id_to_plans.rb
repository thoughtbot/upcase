class AddAnnualPlanIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :annual_plan_id, :integer
    add_index :plans, :annual_plan_id
  end
end
