class AddLengthInDaysToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :length_in_days, :integer
  end
end
