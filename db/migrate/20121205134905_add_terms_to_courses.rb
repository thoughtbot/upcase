class AddTermsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :terms, :text
  end
end
