class RemoveOfficeHoursFeature < ActiveRecord::Migration
  def up
    remove_column :plans, :includes_office_hours
  end

  def down
    add_column(
      :plans,
      :includes_office_hours,
      :boolean,
      default: true,
      null: false
    )
  end
end
