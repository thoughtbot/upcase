class AddLengthInDaysToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :length_in_days, :integer
  end
end
