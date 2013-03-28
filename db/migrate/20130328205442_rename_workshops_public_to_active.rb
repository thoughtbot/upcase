class RenameWorkshopsPublicToActive < ActiveRecord::Migration
  def change
    rename_column :workshops, :public, :active
  end
end
