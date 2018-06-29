class AddDeactivatedOnToSubscriptions < ActiveRecord::Migration[4.2]
  def up
    change_table :subscriptions do |t|
      t.date :deactivated_on
    end
  end

  def down
    change_table :subscriptions do |t|
      t.remove :deactivated_on
    end
  end
end
