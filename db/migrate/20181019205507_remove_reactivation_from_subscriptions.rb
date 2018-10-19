class RemoveReactivationFromSubscriptions < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :scheduled_for_reactivation_on, :date
    remove_column :subscriptions, :reactivated_on, :date
  end
end
