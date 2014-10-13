class AddDescriptionToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :description, :text, null: false, default: ""
  end
end
