class AllowNullMaximimStudentsOnWorkshops < ActiveRecord::Migration
  def up
    change_column :workshops, :maximum_students, :integer, null: true, default: nil
    update 'update workshops set maximum_students = NULL where online = true'
  end

  def down
    change_column :workshops, :maximum_students, :integer, null: false, default: 12
  end
end
