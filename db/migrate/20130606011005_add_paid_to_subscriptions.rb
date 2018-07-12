class AddPaidToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :paid, :boolean, default: true, null: false
  end
end
