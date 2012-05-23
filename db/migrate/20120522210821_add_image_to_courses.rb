class AddImageToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_image_file_name, :string
    add_column :courses, :course_image_file_size, :string
    add_column :courses, :course_image_content_type, :string
    add_column :courses, :course_image_updated_at, :string
  end
end
