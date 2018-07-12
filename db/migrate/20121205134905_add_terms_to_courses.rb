class AddTermsToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :terms, :text
  end
end
