class AddOnlineToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :online, :boolean, null: false, default: false
  end
end
