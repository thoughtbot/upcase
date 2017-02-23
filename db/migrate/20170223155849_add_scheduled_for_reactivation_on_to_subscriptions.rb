class AddScheduledForReactivationOnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :scheduled_for_reactivation_on, :date
  end
end
