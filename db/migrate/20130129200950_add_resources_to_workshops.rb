class AddResourcesToWorkshops < ActiveRecord::Migration[4.2]
  def change
    add_column :workshops, :resources, :text, null: false, default: ""
  end
end
