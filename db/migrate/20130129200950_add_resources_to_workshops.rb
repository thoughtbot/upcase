class AddResourcesToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :resources, :text, null: false, default: ''
  end
end
