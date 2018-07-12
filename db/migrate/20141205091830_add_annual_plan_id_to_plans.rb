class AddAnnualPlanIdToPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :plans, :annual_plan_id, :integer
    add_index :plans, :annual_plan_id
  end
end
