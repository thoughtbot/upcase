class AddExternalRegistrationUrlToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :external_registration_url, :string
  end

  def self.down
    remove_column :courses, :external_registration_url
  end
end
