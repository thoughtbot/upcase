class CorrectlySpellCancellation < ActiveRecord::Migration
  def up
    rename_column :subscriptions,
      :scheduled_for_cancelation_on,
      :scheduled_for_cancellation_on
  end

  def down
    rename_column :subscriptions,
      :scheduled_for_cancellation_on,
      :scheduled_for_cancelation_on
  end
end
