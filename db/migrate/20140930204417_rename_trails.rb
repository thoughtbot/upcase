class RenameTrails < ActiveRecord::Migration[4.2]
  def change
    rename_table :trails, :legacy_trails
  end
end
