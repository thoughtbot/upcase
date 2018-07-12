class RenameCoursesToWorkshops < ActiveRecord::Migration[4.2]
  def change
    rename_table :courses, :workshops

    %w(follow_ups questions sections).each do |table_name|
      rename_column table_name, :course_id, :workshop_id
    end
  end
end
