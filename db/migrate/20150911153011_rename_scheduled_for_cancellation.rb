class RenameScheduledForCancellation < ActiveRecord::Migration
  def change
    rename_column(
      :subscriptions,
      :scheduled_for_cancellation_on,
      :scheduled_for_deactivation_on,
    )
  end
end
