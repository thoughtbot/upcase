class AddAccessibleWithoutSubscriptionToVideo < ActiveRecord::Migration[4.2]
  def change
    add_column(
      :videos,
      :accessible_without_subscription,
      :boolean,
      default: false,
    )
  end
end
