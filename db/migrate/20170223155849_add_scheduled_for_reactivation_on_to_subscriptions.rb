class AddScheduledForReactivationOnToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :scheduled_for_reactivation_on, :date
  end
end
