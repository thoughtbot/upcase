class AddAccessibleWithoutSubscriptionToVideo < ActiveRecord::Migration
  def change
    add_column(
      :videos,
      :accessible_without_subscription,
      :boolean,
      default: false,
    )
  end
end
