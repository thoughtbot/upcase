class RemoveSubscriptions < ActiveRecord::Migration[5.2]
  def change
    drop_table :subscriptions
  end
end
