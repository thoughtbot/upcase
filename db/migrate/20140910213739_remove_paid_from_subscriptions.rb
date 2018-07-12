class RemovePaidFromSubscriptions < ActiveRecord::Migration[4.2]
  def up
    remove_column :subscriptions, :paid
  end

  def down
    add_column :subscriptions, :paid, :boolean, default: true, null: false
  end
end
