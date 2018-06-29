class AddScheduledForCancelationOnToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :scheduled_for_cancelation_on, :date
  end
end
