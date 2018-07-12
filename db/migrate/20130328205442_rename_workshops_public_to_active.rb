class RenameWorkshopsPublicToActive < ActiveRecord::Migration[4.2]
  def change
    rename_column :workshops, :public, :active
  end
end
