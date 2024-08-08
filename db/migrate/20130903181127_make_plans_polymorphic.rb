class MakePlansPolymorphic < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :plan_type, :string, null: false, default: "IndividualPlan"
  end
end
