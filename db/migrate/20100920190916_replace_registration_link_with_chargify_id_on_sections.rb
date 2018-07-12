class ReplaceRegistrationLinkWithChargifyIdOnSections < ActiveRecord::Migration[4.2]
  def self.up
    remove_column :sections, :registration_link
    add_column :sections, :chargify_id, :string
  end

  def self.down
    remove_column :sections, :chargify_id
    add_column :sections, :registration_link
  end
end
