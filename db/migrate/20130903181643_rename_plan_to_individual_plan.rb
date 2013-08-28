class RenamePlanToIndividualPlan < ActiveRecord::Migration
  def change
    rename_table :plans, :individual_plans
  end
end
