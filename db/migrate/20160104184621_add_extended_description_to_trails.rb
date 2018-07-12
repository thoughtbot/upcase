class AddExtendedDescriptionToTrails < ActiveRecord::Migration[4.2]
  def change
    add_column :trails, :extended_description, :text
  end
end
