class AddReactivatedOnToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :reactivated_on, :date
  end
end
