class AddStartAtAndStopAtToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :start_at, :time
    add_column :sections, :stop_at, :time

    update "UPDATE sections SET start_at = courses.start_at, stop_at = courses.stop_at FROM courses where course_id = courses.id"
  end

  def self.down
    remove_column :sections, :stop_at
    remove_column :sections, :start_at
  end
end
