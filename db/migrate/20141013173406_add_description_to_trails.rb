class AddDescriptionToTrails < ActiveRecord::Migration[4.2]
  def change
    add_column :trails, :description, :text, null: false, default: ""
  end
end
