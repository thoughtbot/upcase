class RemoveTermsOfServiceFromCourses < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :courses, :terms_of_service
  end

  def self.down
    add_column :courses, :terms_of_service, :text
  end
end
