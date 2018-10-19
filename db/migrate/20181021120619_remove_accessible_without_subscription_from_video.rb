class RemoveAccessibleWithoutSubscriptionFromVideo < ActiveRecord::Migration[5.2]
  def change
    remove_column :videos, :accessible_without_subscription
  end
end
