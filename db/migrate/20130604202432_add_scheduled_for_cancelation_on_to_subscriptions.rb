class AddScheduledForCancelationOnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :scheduled_for_cancelation_on, :date
  end
end
