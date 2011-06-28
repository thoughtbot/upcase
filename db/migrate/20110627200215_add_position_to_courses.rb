class AddPositionToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :position, :integer
  end

  def self.down
    remove_column :courses, :position
  end
end
