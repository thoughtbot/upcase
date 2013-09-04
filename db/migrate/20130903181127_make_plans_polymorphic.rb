class MakePlansPolymorphic < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_type, :string, null: false
  end
end
