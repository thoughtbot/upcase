class AddExternalRegistrationUrlToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :external_registration_url, :string
  end

  def self.down
    remove_column :courses, :external_registration_url
  end
end
