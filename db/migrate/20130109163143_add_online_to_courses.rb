class AddOnlineToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :online, :boolean, null: false, default: false
  end
end
