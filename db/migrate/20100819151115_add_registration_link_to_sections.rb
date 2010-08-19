class AddRegistrationLinkToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :registration_link, :string, :null => false, :default => ''
  end

  def self.down
    remove_column :sections, :registration_link
  end
end
