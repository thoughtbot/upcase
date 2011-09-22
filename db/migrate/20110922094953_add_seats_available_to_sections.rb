class AddSeatsAvailableToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :seats_available, :integer
  end

  def self.down
    remove_column :sections, :seats_available
  end
end
