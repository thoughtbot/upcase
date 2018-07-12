class AddPositionToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :position, :integer
  end

  def self.down
    remove_column :courses, :position
  end
end
