class AddReactivatedOnToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :reactivated_on, :date
  end
end
