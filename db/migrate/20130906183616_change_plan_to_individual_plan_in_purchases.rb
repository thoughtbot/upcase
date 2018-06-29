class ChangePlanToIndividualPlanInPurchases < ActiveRecord::Migration[4.2]
  def up
    execute <<-SQL
      UPDATE purchases
      SET purchaseable_type = 'IndividualPlan'
      WHERE purchaseable_type = 'Plan'
    SQL
  end

  def down
    execute <<-SQL
      UPDATE purchases
      SET purchaseable_type = 'Plan'
      WHERE purchaseable_type = 'IndividualPlan'
    SQL
  end
end
