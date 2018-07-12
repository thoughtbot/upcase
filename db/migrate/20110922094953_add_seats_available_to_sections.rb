class AddSeatsAvailableToSections < ActiveRecord::Migration[4.2]
  def self.up
    add_column :sections, :seats_available, :integer
  end

  def self.down
    remove_column :sections, :seats_available
  end
end
