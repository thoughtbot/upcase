class AddAddressesToSections < ActiveRecord::Migration
  def up
    add_column :sections, :address, :string
    add_column :sections, :city, :string
    add_column :sections, :state, :string
    add_column :sections, :zip, :string
    update "update sections set address = courses.location || '\n' || courses.location_name from courses where sections.course_id=courses.id"
    remove_column :courses, :location
    remove_column :courses, :location_name
  end

  def down
    add_column :courses, :location_name, :string
    add_column :courses, :location, :string
    update "update courses set location = sections.address from sections where sections.course_id=courses.id"
    remove_column :sections, :address
    remove_column :sections, :city
    remove_column :sections, :state
    remove_column :sections, :zip
  end
end
