class RenameIndividualPlansToPlans < ActiveRecord::Migration[4.2]
  def change
    rename_table :individual_plans, :plans
  end
end
