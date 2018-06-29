class RemoveOfficeHoursFeature < ActiveRecord::Migration[4.2]
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
