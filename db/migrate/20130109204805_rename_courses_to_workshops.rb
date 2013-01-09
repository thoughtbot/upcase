class RenameCoursesToWorkshops < ActiveRecord::Migration
  def change
    rename_table :courses, :workshops
    rename_index 'workshops', 'index_courses_on_audience_id',
      'index_workshops_on_audience_id'

    %w(follow_ups questions sections).each do |table_name|
      rename_column table_name, :course_id, :workshop_id
      rename_index table_name, "index_#{table_name}_on_course_id",
        "index_#{table_name}_on_workshop_id"
    end
  end
end
