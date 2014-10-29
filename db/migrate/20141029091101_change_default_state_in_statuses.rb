class ChangeDefaultStateInStatuses < ActiveRecord::Migration
  def up
    change_column_default :statuses, :state, "In Progress"
  end

  def down
    change_column_default :statuses, :state, "Started"
  end
end
