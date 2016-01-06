class AddExtendedDescriptionToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :extended_description, :text
  end
end
