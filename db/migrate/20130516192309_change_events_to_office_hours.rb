class ChangeEventsToOfficeHours < ActiveRecord::Migration[4.2]
  def up
    rename_table :events, :office_hours
    add_column :office_hours, :occurs_in_week, :integer
    rename_column :office_hours, :occurs_on_day, :occurs_on_week_day
  end

  def down
    rename_column :office_hours, :occurs_on_week_day, :occurs_on_day
    remove_column :office_hours, :occurs_in_week
    rename_table :office_hours, :events
  end
end
