class AddIsAnnualToPlans < ActiveRecord::Migration[4.2]
  def change
    add_column :plans, :annual, :boolean, nil: false, default: false
  end
end
