class RemoveImageColumnsFromWorkshops < ActiveRecord::Migration
  def self.up
    change_table :workshops do |t|
      t.remove :course_image_file_name
      t.remove :course_image_file_size
      t.remove :course_image_content_type
      t.remove :course_image_updated_at
    end
  end

  def self.down
    change_table :workshops do |t|
      t.string :course_image_file_name
      t.string :course_image_file_size
      t.string :course_image_content_type
      t.string :course_image_updated_at
    end
  end
end
