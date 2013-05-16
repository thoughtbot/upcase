class AddDeactivatedOnToSubscriptions < ActiveRecord::Migration
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
