class RenamePlanToIndividualPlan < ActiveRecord::Migration[4.2]
  def change
    rename_table :plans, :individual_plans
  end
end
