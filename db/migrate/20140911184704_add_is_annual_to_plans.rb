class AddIsAnnualToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :annual, :boolean, nil: false, default: false
  end
end
