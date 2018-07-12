class AddLocationNameToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :location_name, :string, :default => ''
  end

  def self.down
    remove_column :courses, :location_name
  end
end
