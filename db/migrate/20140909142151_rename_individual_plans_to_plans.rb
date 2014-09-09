class RenameIndividualPlansToPlans < ActiveRecord::Migration
  def change
    rename_table :individual_plans, :plans
  end
end
