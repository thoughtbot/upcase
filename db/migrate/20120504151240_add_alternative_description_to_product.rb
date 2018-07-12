class AddAlternativeDescriptionToProduct < ActiveRecord::Migration[4.2]
  def self.up
    add_column :products, :alternative_description, :text
  end

  def self.down
    remove_column :products, :alternative_description
  end
end
