class AddShortDescriptionToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :short_description, :string
  end

  def self.down
    remove_column :courses, :short_description
  end
end
